Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3D864CEE3
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 18:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbiLNRc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 12:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiLNRc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 12:32:26 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B31E25
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 09:32:23 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id r130so3214157oih.2
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 09:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tisceqTrZgZHEBYw4sLfyBMHJJXBcRo1sv/VbIN8aBA=;
        b=hhvXbFg9NpkKoSNWsKdzXNNMfwqHT/vcn2W5fd0tDeClVIj+gzgULkWme/Tt0Yio1r
         hE2Fn9WzWPT/M+i3+UQgO8CwnKOrUdPU6ZIZcpRL2QT1zyHT/e3JDUi2tcCcFUv9bx/x
         VRV4+87dpaKr9mI9W0vTmRHU8FcxjG3t4iMQRaCvNbWwR8xg6fWX0/NppJPWrkv/RzHS
         mG6BXk1b5byDTfYAOQ3G7GIr5kZziXoHLlVzHHD+7kM493yTj/MtjGL+m8FSdfopg4Ph
         WCGYbg4g2IiEiDsSEGvsHhS/ammgD+5M71dMjWIIiPcR2aI0oecVnPBnp2gCcv4KSEoG
         A3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tisceqTrZgZHEBYw4sLfyBMHJJXBcRo1sv/VbIN8aBA=;
        b=I+yyYamDWT6amzX8dneW+hDgAlOkG1677Wfk4tlscYqDchwcyW2jzz6KRC4Szyeb7H
         yDWOuwWcbJPEBFeMcIoJYWF6UNu+1DapKL464s0PYeaVUVw+2QTEEVoN4kk8fh/vUbWK
         MBi6xs5qpyHlYvLQOFx2SAvj9p2va8G/KWb2WOI8iwSqy2mMrepBlW6VFFWDMzQzRPmX
         zq+vm+ubdOwACowsOHG3Q1lAo7BGl1Z5Q6bgS1c2b/IfVDpUzW+ay8rRrRn4G/AUp6HK
         eJgqW19Z+wtDbXOupyf2aPwfdOFqwd8pEF339T7HxaPgoBlvAqei3KzOoLjDebXim9j5
         etpQ==
X-Gm-Message-State: ANoB5pnRb7xXbIkyz47Am6R004k3XydzbtaHuEbWRzQbFHLfgpE7OVXr
        nQ8s9MdjbR7xHINI7ItsLdl62VJe3CwPKzeoyIyAdA==
X-Google-Smtp-Source: AA0mqf46ex4InI18kvUFgzLZrVUvxabGAetBKYDY0H3aBe6UJctGcmJGSxl8gelEwhzmPKPfk1PWVwItgEYMjO6Pgu0=
X-Received: by 2002:a05:6808:153:b0:35a:d6c8:bfcf with SMTP id
 h19-20020a056808015300b0035ad6c8bfcfmr232298oie.123.1671039142682; Wed, 14
 Dec 2022 09:32:22 -0800 (PST)
MIME-Version: 1.0
References: <20221213215339.3697182-1-meenashanmugam@google.com> <Y5mO81n3ocBeLOdR@kroah.com>
In-Reply-To: <Y5mO81n3ocBeLOdR@kroah.com>
From:   Meena Shanmugam <meenashanmugam@google.com>
Date:   Wed, 14 Dec 2022 09:32:11 -0800
Message-ID: <CAMdnWFCuXzg=KUM4o9yD-5bpf5qnw=ya3FwVWPK=m1qnJ7vEyw@mail.gmail.com>
Subject: Re: [PATCH 5.15 0/1] Request to cherry-pick 74e7e1efdad4 to 5.15.y
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, jgross@suse.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 14, 2022 at 12:53 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 13, 2022 at 09:53:38PM +0000, Meena Shanmugam wrote:
> > The commit 74e7e1efdad4 (xen/netback: don't call kfree_skb() with
> > interrupts disabled) fixes deadlock in Linux netback driver. This seems
> > to be a good candidate for the stable trees. This patch didn't apply
> > cleanly in 5.15 kernel due to difference in function prototypes in
> > drivers/net/xen-netback/common.h.
> >
> > Juergen Gross (1):
> >   xen/netback: don't call kfree_skb() with interrupts disabled
> >
> >  drivers/net/xen-netback/common.h    | 2 +-
> >  drivers/net/xen-netback/interface.c | 6 ++++--
> >  drivers/net/xen-netback/rx.c        | 8 +++++---
> >  3 files changed, 10 insertions(+), 6 deletions(-)
> >
> > --
> > 2.39.0.rc1.256.g54fd8350bd-goog
> >
>
> Can you just test the latest stable -rc releases that were announced a
> few days ago instead?  It has this commit in it, right?
>
> thanks,
>
> greg k-h

Sorry, I was testing using 5.15.82 and I didn't realize that it was
already queued for 5.15.83.

Thanks,
Meena
