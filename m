Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC865ACBC6
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 09:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiIEHEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 03:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbiIEHEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 03:04:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FF91D332;
        Mon,  5 Sep 2022 00:04:14 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id nc14so15117882ejc.4;
        Mon, 05 Sep 2022 00:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=jHtrYfQ4qegDWR4vNTD6kzy5d+gw5y97ns1jclLRFNk=;
        b=JswWWTBKxMUnAdK40ElQP6RgbhP8l44zuWGQVHOVZgSu/MVr/LEI1nwiDD6sDB5tZy
         SXgM0MUAr4ZsNr9JyqWcAHUnbMyMFs358KJWrdONsGHahyl4C6esqji0hXgN54r+Pf2d
         7mVjZtN/xYTXxnvXF2lfxKiSiqs2wKNcU5D9tLxfpa+4fL+AUaXTrojbyfxPvEe2X7fs
         DxFvjFxxuBrExs+/jb7kNlHz/AY92XZS3QsO4dk5ImU+SEpMOlxO3U6c0mXGlZ1rVamR
         0f5eRVl00S+LVcyyj5xeUfeo7h2+0lujEmJDvLB4RWdtg4cSKLJdzS0GoDgqxhqeAvqa
         GYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jHtrYfQ4qegDWR4vNTD6kzy5d+gw5y97ns1jclLRFNk=;
        b=C4fA+BOF2/e+ecVU03ALe5f0a+DMJ/MGAOgMs7+/vB7omTl5tlkBRPUxeCt2iFi2z3
         shad0WHshgcmHt4SRiUQDLRY7G/oPz2fPLkSZsewZKyxFHLcFSeoEOA4nMOa5rx++WTY
         wdRPagh0vqz7rq220q4z4Dfn1OrgXpelkMND4HBm2dBqXybFlx+9vkP2e8XG0xFwEI5O
         4a22SKfr4OiQwkDXEd2HhnthOz/54Ew+F6VXf6GZpVYKpImDzewfq7rRTobZVZ9cCtJk
         jnu6/zdjVCZI8VIPdT8ckiO/TK46T9w1XsZ/4ShJh6CEqYtm/IYtfq5fYPUX+RzcjATu
         VUWQ==
X-Gm-Message-State: ACgBeo3bVlIIOLTzoPs4hFkcfTAfT+CMQISScYq+rUES0zU/siaQmpDG
        +zubANI9hJwn3OhfX1rhdC8=
X-Google-Smtp-Source: AA6agR79hJ+rZuATRSftwRNd3+McHCOH4sPNVi6XD5dOI4VIkuZjtqClq1Y7hOUFODIEwO6lw4RPOQ==
X-Received: by 2002:a17:907:2cd3:b0:741:550e:17ea with SMTP id hg19-20020a1709072cd300b00741550e17eamr27104870ejc.595.1662361452501;
        Mon, 05 Sep 2022 00:04:12 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5880354edd.48.2022.09.05.00.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:04:12 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 5 Sep 2022 09:04:10 +0200
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH stable 5.15 0/2] kbuild: Fix compilation for latest
 pahole release
Message-ID: <YxWfaoImsdcvkbce@krava>
References: <20220904131901.13025-1-jolsa@kernel.org>
 <YxSxwZWkYMmtcsmA@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxSxwZWkYMmtcsmA@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 04, 2022 at 04:10:09PM +0200, Greg KH wrote:
> On Sun, Sep 04, 2022 at 03:18:59PM +0200, Jiri Olsa wrote:
> > hi,
> > new version of pahole (1.24) is causing compilation fail for 5.15
> > stable kernel, discussed in here [1][2]. Sending fix for that plus
> > one dependency patch.
> > 
> > Note for patch 1:
> > there was one extra line change in scripts/pahole-flags.sh file in
> > its linux tree merge commit:
> > 
> >   fc02cb2b37fe Merge tag 'net-next-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > 
> > not sure how/if to track that, I squashed the change in.
> 
> Squashing is fine, thanks.
> 
> And do we also need this for kernels older than 5.15?  Like 5.10 and 5.4?

yes, 5.10 needs similar patchset, but this for 5.15 won't apply there,
so I'll send it separately

5.4 passes compilation, but I don't think it will boot properly, still
need to check on that

in any case, more patches are coming ;-)

jirka
