Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E585454CB72
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 16:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiFOOgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 10:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiFOOgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 10:36:46 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C603AA77
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 07:36:46 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m14so180634plg.5
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 07:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vttPuOhvTXbiLEEhPovlRRfss5Fl6l3AC5Df+QtEYl0=;
        b=dECz2tOscedwKb10nqiExX/aMHC/mruVf9z0I2p/kXEV6ZXYpdgE2V83HMwyCNgVUc
         8dt5yI79h6Ev+uZqFG923gjG8qGv5LbEpvhmxcrBK1Fmtc7qSM/hPNHSYQdukZpkRjn8
         EKgTs0LFaVopUbgeFqtJEJCYRMbXcDrLm8ajufLSTPikFoVktgEtIUtW2nvGlRz629pf
         qfsl16YQcuJRQaaX5L3s/eodpBctqMdW4VbLm5dtyGSefVO3nYxcbK3d92MIZFhV+e56
         O6odxHx+xAQU5HoqHEFO+d0GAwebErvxvwWs4+7L+amsnWIiRjxV8qW5aEpOX+nxqoke
         ar/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vttPuOhvTXbiLEEhPovlRRfss5Fl6l3AC5Df+QtEYl0=;
        b=eW4m5UggVwqO4KQgQSoveuvEikVP7PNllprKYe0ARX+jVCGzTYNmIltIzCP6KJPHE2
         TOej+xCWhtkpCevHjzaZf/f7/W4+cFS9E3n14idTJRAkq+s0eGwcsCJwn0p0Se36rbUc
         Cr5GZndICW6H86xksyQ0IUWIUc4env3BGMRDac32ailgOHuPZv+g0TSsPzNP3bfb3Bsc
         N6fyddGu//+VSq+m29ReYvJLkk8cH8c6C3gwrn5ES8D5jrs9e3zSIViEdBIENBYdqwLv
         aFz2wvFWLcpPNPdj+n6Gp5Ste7uExcJPaLRb9snyaW4VjbcGJkj/fYWUN8I0YH8PGTZw
         ewYg==
X-Gm-Message-State: AJIora8Aueqk1ZDbMJcVD3AeaUnhGGCh6nOB5HvxEyTuUeYvYnWWQYqB
        up72+Syr6+yfv5nS7QDKJQ8=
X-Google-Smtp-Source: AGRyM1vIm4gzXJ/NN8VDQYgmf13YxaBHhPpLOyInhdNWbwcC/B2THPrqwJu3gsxJg1yjhnlgnMkzVg==
X-Received: by 2002:a17:90b:2251:b0:1e6:76a8:44f3 with SMTP id hk17-20020a17090b225100b001e676a844f3mr10778425pjb.71.1655303805360;
        Wed, 15 Jun 2022 07:36:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902f78200b00164ade949adsm9482353pln.79.2022.06.15.07.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 07:36:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Jun 2022 07:36:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        Oleksandr Tymoshenko <ovt@google.com>, keescook@chromium.org,
        sarthakkukreti@google.com, stable@vger.kernel.org,
        regressions@lists.linux.dev, dm-devel@redhat.com
Subject: Re: [PATCH 5.4 26/34] dm verity: set DM_TARGET_IMMUTABLE feature flag
Message-ID: <20220615143642.GA2386944@roeck-us.net>
References: <20220603173816.944766454@linuxfoundation.org>
 <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqb/sT205Lrhl6Bv@kroah.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 11:13:21AM +0200, Greg KH wrote:
> On Fri, Jun 10, 2022 at 11:11:00AM -0400, Mike Snitzer wrote:
> > On Fri, Jun 10 2022 at  1:15P -0400,
> > Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Fri, Jun 10, 2022 at 04:22:00AM +0000, Oleksandr Tymoshenko wrote:
> > > > I believe this commit introduced a regression in dm verity on systems
> > > > where data device is an NVME one. Loading table fails with the
> > > > following diagnostics:
> > > > 
> > > > device-mapper: table: table load rejected: including non-request-stackable devices
> > > > 
> > > > The same kernel works with the same data drive on the SCSI interface.
> > > > NVME-backed dm verity works with just this commit reverted.
> > > > 
> > > > I believe the presence of the immutable partition is used as an indicator
> > > > of special case NVME configuration and if the data device's name starts
> > > > with "nvme" the code tries to switch the target type to
> > > > DM_TYPE_NVME_BIO_BASED (drivers/md/dm-table.c lines 1003-1010).
> > > > 
> > > > The special NVME optimization case was removed in
> > > > 5.10 by commit 9c37de297f6590937f95a28bec1b7ac68a38618f, so only 5.4 is
> > > > affected.
> > > > 
> > > 
> > > Why wouldn't 4.9, 4.14, and 4.19 also be affected here?  Should I also
> > > just queue up 9c37de297f65 ("dm: remove special-casing of bio-based
> > > immutable singleton target on NVMe") to those older kernels?  If so,
> > > have you tested this and verified that it worked?
> > 
> > Sorry for the unforeseen stable@ troubles here!
> > 
> > In general we'd be fine to apply commit 9c37de297f65 but to do it
> > properly would require also making sure commits that remove
> > "DM_TYPE_NVME_BIO_BASED", like 8d47e65948dd ("dm mpath: remove
> > unnecessary NVMe branching in favor of scsi_dh checks") are applied --
> > basically any lingering references to DM_TYPE_NVME_BIO_BASED need to
> > be removed.
> > 
> > The commit header for 8d47e65948dd documents what
> > DM_TYPE_NVME_BIO_BASED was used for.. it was dm-mpath specific and
> > "nvme" mode really never got used by any userspace that I'm aware of.
> > 
> > Sadly I currently don't have the time to do this backport for all N
> > stable kernels... :(
> > 
> > But if that backport gets out of control: A simpler, albeit stable@
> > unicorn, way to resolve this is to simply revert 9c37de297f65 and make

9c37de297f65 can not be reverted in 5.4 and older because it isn't there,
and trying to apply it results in conflicts which at least I can not
resolve.

> > it so that DM-mpath and DM core just used bio-based if "nvme" is
> > requested by dm-mpath, so also in drivers/md/dm-mpath.c e.g.:
> > 
> > @@ -1091,8 +1088,6 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
> > 
> >                         if (!strcasecmp(queue_mode_name, "bio"))
> >                                 m->queue_mode = DM_TYPE_BIO_BASED;
> > 			else if (!strcasecmp(queue_mode_name, "nvme"))
> > -                               m->queue_mode = DM_TYPE_NVME_BIO_BASED;
> > +                               m->queue_mode = DM_TYPE_BIO_BASED;
> >                         else if (!strcasecmp(queue_mode_name, "rq"))
> >                                 m->queue_mode = DM_TYPE_REQUEST_BASED;
> >                         else if (!strcasecmp(queue_mode_name, "mq"))
> > 
> > Mike
> > 
> 
> Ok, please submit a working patch for the kernels that need it so that
> we can review and apply it to solve this regression.
> 

So, effectively, v5.4.y and older are broken right now for use cases
with dm on NVME drives.

Given that the regression does affect older branches, and given that we
have to revert this patch to avoid regressions in ChromeOS, would it be
possible to revert it from v5.4.y and older until a fix is found ?

Thanks,
Guenter
