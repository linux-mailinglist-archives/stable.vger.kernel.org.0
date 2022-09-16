Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97B95BADBF
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 15:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiIPNBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiIPNBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 09:01:41 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F5DA8CF3;
        Fri, 16 Sep 2022 06:01:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z21so31389527edi.1;
        Fri, 16 Sep 2022 06:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=wcWSAqU0RnI6c//4sqrGDKdpSAoCJZ3J96FsLTUPuas=;
        b=nhYa1Y4o0rFmzOmkVxzBk+0avswF1nz1+vTZAu1wwRIax52Lc4T7Us7s1R1uJomXJz
         yLqK/k4w37w/YtFjW1iejEUg7qw6XHLX+hhoQMaSVC+lCDJI3vUrtOtyWfilsXrobTGb
         AmfDT3biRelLi6Ab38ejZq3RX084JiDwrw9Mxs1CChAkWV6hKCVJfGBpzIPQmDuGt6vE
         7fWyuRi6iq8O1tOkRWtfgjJbng7AVtCijKZ/rZJIGYeLH6fKh3+bzo1PFFmD9rVW5TSr
         /HAKgIxyxpi3Nd+hK3xRb6b1vkGm+ktH+CDeegBmvkAmyVcoCUcD7bjapZmjOPozeeJt
         9FqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=wcWSAqU0RnI6c//4sqrGDKdpSAoCJZ3J96FsLTUPuas=;
        b=b0TZI48TDKe45ksE3AEjbGuIuTe8+sN4V9jTCJYvTXfsX4pdB+xRmRQgYF0SPH1vC/
         //YZmm6Rxfwj6s0mnYRKVMfbtDNSN82BYN33q5xDcXE5THbmZxWLfKohqrVtxeeFwRUU
         mpQvZ5sfYXjRKBlRN9V1R+sejwbsMjrj0Z+z49TGkPX9dZT5xQAluCrs+tqvfmcMOuXM
         z1HDEGObWdcqAVUyqRjk2YmndVYphTbEWpZjA4ZHJNVnqBc7lME+JACcDuEkHsJpQKeG
         Z6bS+trLKnh63twfuIW1i6aX/w2LzPl+5aH5+ZOVbLzb2zivtklK+y2atS2W3TWjqwje
         znkw==
X-Gm-Message-State: ACrzQf0CqT+gtkSRvuYDTQ4iqgcjAOd3pVwcS2MrQK2VEzK1rllUwFAI
        LoVjmlxqRaygOj1NrJuNbdY=
X-Google-Smtp-Source: AMsMyM4Sc91X47MIkkBgsd8SFs3gOQzTVf/6f/BFLL0h17Ai5vnhAzVIHZSB5iFlYQ6CIIixATKNnw==
X-Received: by 2002:a05:6402:3806:b0:450:bad8:8cd5 with SMTP id es6-20020a056402380600b00450bad88cd5mr3938589edb.305.1663333287882;
        Fri, 16 Sep 2022 06:01:27 -0700 (PDT)
Received: from krava ([2a00:102a:500c:b611:39fb:ad02:4ca6:a08])
        by smtp.gmail.com with ESMTPSA id my39-20020a1709065a6700b0073d9a0d0cbcsm10287474ejc.72.2022.09.16.06.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 06:01:27 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 16 Sep 2022 15:01:24 +0200
To:     Thorsten Leemhuis <linux@leemhuis.info>
Cc:     Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 102/107] kbuild: Add skip_encoding_btf_enum64 option
 to pahole
Message-ID: <YyRzpJ1dzAPpMBz7@krava>
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132826.180891759@linuxfoundation.org>
 <20ad29b8-be2c-8c1e-bd34-9709e5a9922f@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20ad29b8-be2c-8c1e-bd34-9709e5a9922f@leemhuis.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 11:21:46AM +0100, Thorsten Leemhuis wrote:
> On 06.09.22 14:31, Greg Kroah-Hartman wrote:
> > From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> > 
> > New pahole (version 1.24) generates by default new BTF_KIND_ENUM64 BTF tag,
> > which is not supported by stable kernel.
> 
> Martin, when you wrote "not supported by stable kernel", did you mean
> just 5.15.y or 5.19.y as well? Because I ran into...
> 
> > As a result the kernel with CONFIG_DEBUG_INFO_BTF option will fail to
> > compile with following error:
> > 
> >   BTFIDS  vmlinux
> > FAILED: load BTF from vmlinux: Invalid argument
> 
> ...this compile error when compiling 5.19.9 for F37 and from a quick
> look into this it seems this was caused by a update of dwarves to 1.24
> that recently landed in that distribution. This patch seems to fix the
> problem (it got past the point of the error, but modules are still
> compiling).

hi,
IIUC Martin planned to send that for 5.19, I can do that if needed

jirka

> 
> Ciao, Thorsten
> 
> > New pahole provides --skip_encoding_btf_enum64 option to skip BTF_KIND_ENUM64
> > generation and produce BTF supported by stable kernel.
> > 
> > Adding this option to scripts/pahole-flags.sh.
> > 
> > This change does not have equivalent commit in linus tree, because linus tree
> > has support for BTF_KIND_ENUM64 tag, so it does not need to be disabled.
> > 
> > Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  scripts/pahole-flags.sh |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > --- a/scripts/pahole-flags.sh
> > +++ b/scripts/pahole-flags.sh
> > @@ -17,4 +17,8 @@ if [ "${pahole_ver}" -ge "121" ]; then
> >  	extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
> >  fi
> >  
> > +if [ "${pahole_ver}" -ge "124" ]; then
> > +	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
> > +fi
> > +
> >  echo ${extra_paholeopt}
> > 
> > 
