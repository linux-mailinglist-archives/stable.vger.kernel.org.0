Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EB31C0C8B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 05:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgEADYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 23:24:05 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:44962 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728092AbgEADYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 23:24:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588303444; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=rqPW0jdtlYlB8IY0BCAqlxWdajfch16xOITx+u/zZ2o=;
 b=szX8xd5l1nnZItAhq1ypqx/MLEVaSLT8CjRsE5nzhA5Yv2si+bx8cZIl581tP6sc0qRBAgq5
 lfTkol49NBlBZG9H5huJm8yFAH4ZRgd+0q+7W7IVLrxm8GGb9GUStAnsyi9wQBU2No9Rf0Ng
 oba5/lrbbewQoG4tNywjQSDpQlQ=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eab964c.7f63f3a43f10-smtp-out-n03;
 Fri, 01 May 2020 03:23:56 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 80A95C433F2; Fri,  1 May 2020 03:23:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rananta)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A03FFC433CB;
        Fri,  1 May 2020 03:23:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 20:23:54 -0700
From:   rananta@codeaurora.org
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: Request to backport a patch onto 5.4.y stable
In-Reply-To: <20200430233357.GA13035@sasha-vm>
References: <b8f451c80fe1cd57bdd4fea74d21e8cd@codeaurora.org>
 <20200430233357.GA13035@sasha-vm>
Message-ID: <ba319dc2e66986c7cc594f88ce98621c@codeaurora.org>
X-Sender: rananta@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-30 16:33, Sasha Levin wrote:
> On Thu, Apr 30, 2020 at 01:36:45PM -0700, rananta@codeaurora.org wrote:
>> Hi,
>> 
>> I need help to backport the patch with the following details onto the 
>> 5.4.y stable branch:
>> Subject: [PATCH] tty: hvc: Fix data abort due to race in hvc_open
>> commit-id: e2bd1dcbe1aa34ff5570b3427c530e4332ecf0fe
>> Reason: The issue addressed in the patch was discovered on 5.4.y 
>> branch
> 
> Is it in Linus's tree?
It's on linux-next tree:
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/tty/hvc/hvc_console.c?id=e2bd1dcbe1aa34ff5570b3427c530e4332ecf0fe
