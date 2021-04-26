Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AFB36BBBD
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 00:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhDZWhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 18:37:32 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:58093 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232235AbhDZWhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 18:37:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619476609; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=oCnweCBMh3IHM3K4LW+++d+iSCW1tV81y0CJQjgIx7U=; b=dEXN29gWxarHQbiKKiSpi+p0Dhi9sEGh6ylFOzJGMA/GfUfOyZfMzDhmX54GuwQu74uU4Jji
 kxnLdKNB2g/aNFmSykKUFkOp3biDxQKjFj/+zniz9unDB2v0sA5q5XnPCsOgo+9VoOcQcYm1
 7w57wYR0njlALQKeAqakPYGNA7s=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6087407f2cc44d3aeacae960 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Apr 2021 22:36:47
 GMT
Sender: subbaram=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1B7DAC4323A; Mon, 26 Apr 2021 22:36:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from subbaram-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subbaram)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32572C433D3;
        Mon, 26 Apr 2021 22:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 32572C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subbaram@codeaurora.org
From:   Subbaraman Narayanamurthy <subbaram@codeaurora.org>
To:     jackp@codeaurora.org
Cc:     abhilash.k.v@intel.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, subbaram@codeaurora.org
Subject: Re: [PATCH] usb: typec: ucsi: Retrieve all the PDOs instead of just the first 4
Date:   Mon, 26 Apr 2021 15:36:20 -0700
Message-Id: <1619476580-13072-1-git-send-email-subbaram@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20210426204213.GC20698@jackp-linux.qualcomm.com>
References: <20210426204213.GC20698@jackp-linux.qualcomm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> UBSAN FTW. Want me to copy this trace into the commit text as well?

Yes, I think it would be good as this issue is found by enabling UBSAN.
Also, it gives the context that by inserting a PD charger adapter that
can support more than 4 PDOs, device can crash because of an OOB access.

-Subbaraman
