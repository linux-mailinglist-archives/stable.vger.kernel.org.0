Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9C66E1D92
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 09:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjDNHzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 03:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDNHzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 03:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337F26A42
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 00:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1DC6644BA
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 07:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C411C433D2;
        Fri, 14 Apr 2023 07:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681458935;
        bh=cFS3k37zRqVUVpB3OO2arvfT2Cr/mlnH8IWYmE0a9R4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UhrJOXXg++D+XFt+YQZo84L/x74MQvjxniELQ9xw+leQip5pZABSVgWyu+Y03wee0
         6O3AzRGxowzGes8BQy+r+HznPeYitVg4qcOAniu0ZjX3gEVPimP8uG17ALlImxBToI
         ERTsA1KzXsu+/nlSdgfRg+YvBTv2HsF7Ulc38EmU=
Date:   Fri, 14 Apr 2023 09:55:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ping Cheng <pinglinux@gmail.com>
Cc:     "stable # v4 . 10" <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: wacom: Set a default resolution for older tablets
Message-ID: <ZDkG8-9BwOwBETSg@kroah.com>
References: <20230409164229.29777-1-ping.cheng@wacom.com>
 <168139664776.832846.9285685297324282380.b4-ty@redhat.com>
 <CAF8JNhKZvecDxYf3SMf7p4TtQmRC0P6bVagPc=K=0r7h6wtc7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8JNhKZvecDxYf3SMf7p4TtQmRC0P6bVagPc=K=0r7h6wtc7Q@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 13, 2023 at 04:30:33PM -0700, Ping Cheng wrote:
> On Thu, Apr 13, 2023 at 7:37 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > On Sun, 09 Apr 2023 09:42:29 -0700, Ping Cheng wrote:
> > > Some older tablets may not report physical maximum for X/Y
> > > coordinates. Set a default to prevent undefined resolution.
> > >
> > >
> >
> > Applied to hid/hid.git (for-6.4/wacom), thanks!
> >
> > [1/1] HID: wacom: Set a default resolution for older tablets
> >       https://git.kernel.org/hid/hid/c/08a46b4190d3
> 
> This patch can be backported to kernels as early as 3.18. It fixes a
> firmware HID descriptor issue.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
