Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4724C5FD6CF
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJMJQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJMJPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:15:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD163A5
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:15:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD6DA6173B
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC629C433D6;
        Thu, 13 Oct 2022 09:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665652529;
        bh=NSVoBHtx/v9xylrxu6NISpCezpgvGk1nSHXNLuqHq+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOqxnHs9JPeajilAs4GloCz+hZSJTX1yKl3lFbKHsxJxEv5vsFOq/fBmaFrk2Jq2H
         TiLgN7BwcVzM4bvkzGzMtCC5xQod1edUTGlVe9ty3QOV7oM6Qh1X5wY/6PWmw4mip0
         MR3fIMtZYSAxm/lcyUPC+dquYAQonci/hBFsaKaQ=
Date:   Thu, 13 Oct 2022 11:16:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     lvgaofei <lvgaofei@oppo.com>
Cc:     stable@vger.kernel.org, gregkh@google.com, jaegeuk@kernel.org,
        chao@kernel.org, drosen@google.com,
        linux-f2fs-devel@lists.sourceforge.net,
        Hyeong-Jun Kim <hj514.kim@samsung.com>
Subject: Re: [f2fs-dev][PATCH 5.10 5.15]f2fs: invalidate META_MAPPING before
 IPU/DIO write
Message-ID: <Y0fXV46Pwi0ilzsN@kroah.com>
References: <1665642400-410526-1-git-send-email-lvgaofei@oppo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1665642400-410526-1-git-send-email-lvgaofei@oppo.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_50,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 02:26:40PM +0800, lvgaofei wrote:
> ________________________________
> OPPO
> 
> 本电子邮件及其附件含有OPPO公司的保密信息，仅限于邮件指明的收件人使用（包含个人及群组）。禁止任何人在未经授权的情况下以任何形式使用。如果您错收了本邮件，请立即以电子邮件通知发件人并删除本邮件及其附件。
> 
> This e-mail and its attachments contain confidential information from OPPO, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!

Now deleted.
