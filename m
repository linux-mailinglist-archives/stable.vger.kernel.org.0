Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023375FD6A6
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJMJK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJMJK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:10:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516A5371A7
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDF6861737
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B58C433D6;
        Thu, 13 Oct 2022 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665652224;
        bh=j2kKkOd0T3xnPKp9Kx8Cdz/iIwZaZ6+K/EenLQi0hxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M2u4jTOrR33yM79lQjKy9yp+xsFdL+JMr2z07IJf1nc6bDQZSgVLiivCjT1/d5HMU
         /j8qBkjt1nl762MwZ+JmD97lxkdPq77b2wa63U5u9WEJ+EpBYkVJlkYSm3MQ2vRZID
         yfH3LijPed6lxIk6Mh6a4Gq7JCRvAm1cfG/cRgz4=
Date:   Thu, 13 Oct 2022 11:11:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     lvgaofei <lvgaofei@oppo.com>
Cc:     stable@vger.kernel.org, jaegeuk@kernel.org, chao@kernel.org,
        drosen@google.com, linux-f2fs-devel@lists.sourceforge.net,
        Hyeong-Jun Kim <hj514.kim@samsung.com>
Subject: Re: [PATCH] Cherry picked from commit
 e3b49ea36802053f312013fd4ccb6e59920a9f76 [Please apply to 5.10-stable and
 5.15-stable.]
Message-ID: <Y0fWLC28cudpgM2I@kroah.com>
References: <1665628774-388896-1-git-send-email-lvgaofei@oppo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1665628774-388896-1-git-send-email-lvgaofei@oppo.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 10:39:34AM +0800, lvgaofei wrote:
> This e-mail and its attachments contain confidential information from OPPO, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!

Now deleted.  This is not compatible with kernel development for obvious
reasons.

greg k-h
