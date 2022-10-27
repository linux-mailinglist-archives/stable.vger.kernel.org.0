Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC26104E8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiJ0V5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbiJ0V5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:57:22 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2A8900F7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 14:57:17 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id BD950C01D; Thu, 27 Oct 2022 23:57:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1666907838; bh=8fk0AUtXmh2xd6QUxiULFVdQp2Ki1SJ4rb8ILY16RNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6YIZ8UNBbphUGZA9hr3cHyj4tfEBZlMy6ooLw/PMKTy0DZ1BG3EV7mlmASVNrQvE
         2pruc+gzg7sRfA/B0NFY7CpNthx5vFEMV7z4zGf9ivQurbYF50Y6apWDYZjqFsz44N
         /H1/v9BvbkS20hXqHRn5ytwsWxFffn6QCFal9aI1qBsuD/5+/U3CHEpB1lQOdsd7AE
         hnpwP912X46RBredO4tGZh+IU5NvsRYZHettjTCs09FQJ26ZyMiM0dGa6vbQbKaogt
         j/Hl5c/mJv5nrdb6Y5IgQhVYsMHWjm2yrYy6xlPOUhjhDbd3ir3+DBP0u9cIDJvKJ7
         fp9XbgmTteaEA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 90888C009;
        Thu, 27 Oct 2022 23:57:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1666907838; bh=8fk0AUtXmh2xd6QUxiULFVdQp2Ki1SJ4rb8ILY16RNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f6YIZ8UNBbphUGZA9hr3cHyj4tfEBZlMy6ooLw/PMKTy0DZ1BG3EV7mlmASVNrQvE
         2pruc+gzg7sRfA/B0NFY7CpNthx5vFEMV7z4zGf9ivQurbYF50Y6apWDYZjqFsz44N
         /H1/v9BvbkS20hXqHRn5ytwsWxFffn6QCFal9aI1qBsuD/5+/U3CHEpB1lQOdsd7AE
         hnpwP912X46RBredO4tGZh+IU5NvsRYZHettjTCs09FQJ26ZyMiM0dGa6vbQbKaogt
         j/Hl5c/mJv5nrdb6Y5IgQhVYsMHWjm2yrYy6xlPOUhjhDbd3ir3+DBP0u9cIDJvKJ7
         fp9XbgmTteaEA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1873be44;
        Thu, 27 Oct 2022 21:57:10 +0000 (UTC)
Date:   Fri, 28 Oct 2022 06:56:55 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 5.10] kbuild: fix BTF build with pahole 1.24
Message-ID: <Y1r+p9AoqSRpSQVr@codewreck.org>
References: <20221027120158.2791406-1-asmadeus@codewreck.org>
 <Y1qAh6TzBw4b3+TQ@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y1qAh6TzBw4b3+TQ@krava>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jiri Olsa wrote on Thu, Oct 27, 2022 at 02:58:47PM +0200:
> On Thu, Oct 27, 2022 at 09:01:58PM +0900, Dominique Martinet wrote:
> > pahole 1.24 broke builds on kernel <6.0 which do not have the
> > new BTF_KIND_ENUM64 BTF tag.
> > The 5.15 branch fixed this in commit b775fbf532dc01ae53a6fc56168fd30cb4b0c658
> > ("kbuild: Add skip_encoding_btf_enum64 option to pahole"), which
> > we cannot use directly for 5.10 because 5.10 does not have the
> > pahole-flags.sh script, itself introduced in upstream commit
> > 0baced0e0938f2895ceba54038eaf15ed91032e7 ("kbuild: Unify options
> > for BTF generation for vmlinux and modules")
> > 
> > that last commit is difficult to backport as 5.10 does not have BTF
> > for modules support: work around the problem by just copying the
> > pahole-flags.sh script and calling it directly in link-vmlinux.sh,
> > which is hopefully acceptable as the flags are not shared in this tree.
> > 
> > Note that compared to 5.15 the flags script does not have
> > --btf_gen_floats as linux 5.10 did not have that BTF tag yet;
> > but any new flag added to 5.15 will not be able to be added to 5.10 in
> > an identical way for any future breakage.
> > 
> > Cc: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > CC: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> 
> I sent this backport just recently:
>   https://lore.kernel.org/bpf/Y1lkASXgeW0jfP8o@kroah.com/T/#t
> 
> it's split into several patches, hopefuly fixing the issue for you

Ah, sorry I didn't think of checking the lists for an in-flight patch;
this is better than what I've sent and what I would have done if I had
taken the time -- checked patches and they look good to me.

Thanks !
-- 
Dominique
