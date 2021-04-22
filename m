Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5136897A
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 01:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhDVXqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 19:46:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:13310 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVXqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 19:46:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619135172; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=+L9r1bo+j6idEjbq0Y2gXmoCkWQiDFq/43yyvz/MPDc=; b=UwtShHJ1NTCay7IQhvaTO0MXCWxdJuJMd2fDbePaCmuhw4eBzDpfQmpiB9YIdZgKSWhyqhRg
 Me/fdJi3bWalbXl85HbPwYiwcTpCJTP/L8eXs+QB5IVi6+qEMoIzUrGPP3yLtMXdz2KWw+Kp
 9VGDAOxmbP+Hqdx+or0XK9ZTKqA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60820ac2c39407c327c3b607 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 23:46:10
 GMT
Sender: subbaram=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DFF4EC433F1; Thu, 22 Apr 2021 23:46:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from subbaram-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subbaram)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B75C8C433F1;
        Thu, 22 Apr 2021 23:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B75C8C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subbaram@codeaurora.org
From:   Subbaraman Narayanamurthy <subbaram@codeaurora.org>
To:     mka@chromium.org
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, djakov@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, mdtipton@codeaurora.org,
        stable@vger.kernel.org, subbaram@codeaurora.org
Subject: Re: [PATCH] interconnect: qcom: bcm-voter: add a missing of_node_put()
Date:   Thu, 22 Apr 2021 16:46:03 -0700
Message-Id: <1619135163-32535-1-git-send-email-subbaram@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <YIHWmJPcoh4bFKNi@google.com>
References: <YIHWmJPcoh4bFKNi@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
>> Cc: stable@vger.kernel.org

> nit: I think you would typically put tags like 'Cc' or 'Fixed' before
> the 'Signed-off-by' tag.

Sure noted. Thanks.
