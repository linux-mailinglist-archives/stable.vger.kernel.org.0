Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0781C0801
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 22:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgD3Ugs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 16:36:48 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:64325 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbgD3Ugs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 16:36:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588279007; h=Message-ID: Subject: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=IWvKJ320jD87cbBzpMu9y90bgb6R9VmYIWJH+DMoYKA=; b=mYglZgjNMRJKGnpqKrb0uDqOCykzX0KXqeYjWbOhmtnIm3fetSaPygyfjlWNkvFRyZYWcYqI
 QN/VrCdGyxNwnAhHnDcbVLsK3AD4qrj7LT8QTXp3dOXwxdVUu3rLOHrOil2Zb1MitzrrY48J
 B49yz+fDP+wy7a5NJuSSiuSZan8=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eab36df.7f7d5a35f570-smtp-out-n01;
 Thu, 30 Apr 2020 20:36:47 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0542AC433D2; Thu, 30 Apr 2020 20:36:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rananta)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0F0AC433CB
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 20:36:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 13:36:45 -0700
From:   rananta@codeaurora.org
To:     stable@vger.kernel.org
Subject: Request to backport a patch onto 5.4.y stable
Message-ID: <b8f451c80fe1cd57bdd4fea74d21e8cd@codeaurora.org>
X-Sender: rananta@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I need help to backport the patch with the following details onto the 
5.4.y stable branch:
Subject: [PATCH] tty: hvc: Fix data abort due to race in hvc_open
commit-id: e2bd1dcbe1aa34ff5570b3427c530e4332ecf0fe
Reason: The issue addressed in the patch was discovered on 5.4.y branch

Thank you.
Raghavendra
