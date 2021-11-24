Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5EC45C33A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349575AbhKXNg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349568AbhKXNeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 08:34:11 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3245C061D6C
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:18:26 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g14so9460839edb.8
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 04:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7b0541uf3NhTH3k96WOFLGJH+Q20HwDsqzNEY/bBMPk=;
        b=Fr0CNcetrJd0loyEkFxDF6RKDfBvIRsSjA76YmVVVmqYID7wzGId8QEUCEq/x3PCGJ
         1HA7zSSmBt3WyOdtYkJ817+6c3eao2u23R/MLSkktjkXV5qAWrk7sLhtkEOZzO6qSey9
         L8iwr17XtnT1IBVBKrtC09VFqL2q2/+tLRnMAKKU/xCWIjIRmsLDj+zVM1CImtB03kkJ
         zO3bgZF1mhfP4jgJwNlJ82C49WFZmf/0bKWC/2GOF6UQj7oI5PNEwyvdoeaLBjhan+YY
         vDd2iL87mhTW1Fzoc5zsrAxqxOIiqJPBpDvniNvKQGyKBNrr7+2i74qhRpTeD4W2OJGk
         qYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7b0541uf3NhTH3k96WOFLGJH+Q20HwDsqzNEY/bBMPk=;
        b=5wELUFIjT6PRThvh1AgUdAFW1BNd67apIvAA9ld+Irdd8NovekE5xXa4EYtouzXmjv
         Ad1dKw6Z0gavOeeXYj9GIR6RXM4Vn64gC6eRWI59hqT0xpHCHB6F9YWt6pE6v7V7y+t6
         l+UYUhZhZlVRxxn113Ywl2iUp70/+PQSXkUFqTnkUhQqJ00PJbiGQbyTxk8Rh3fmdqea
         ZErofYvmwB2dISZCVFD1G+QV2UFE/7aGznadwMc5p/+Q/brL9HUKsKKQtRaR0R3AMb0Z
         kr4Fz9y+Wf7W5+sHoNJDmlztANRwI9QoIZoIrlwZ+92KNgMtd6bR/X4nvDJH9q65L5by
         gSWQ==
X-Gm-Message-State: AOAM531mLkiKWF8xaqn/eoDiU6WyMfMzU6K0Jtq2JT1EyitZkBHcgdip
        VUnboQLq85ul4hVEwqnvfzxv/eubSeWN4bh8irn7mw==
X-Google-Smtp-Source: ABdhPJwhekmIX1ALmE9Rj3Q02RexcNBlg/qGgWSyfTCTWgwKdznFA3a/6BuKqhm+MFuAq5ytOfnbMGec+om2D3DQXlc=
X-Received: by 2002:a17:907:7f8c:: with SMTP id qk12mr19288105ejc.169.1637756305251;
 Wed, 24 Nov 2021 04:18:25 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYv5fnntoa1vzXp52=TSxCK=U8fV8J-AbE+WmKH1w4ebwg@mail.gmail.com>
 <YZ4gjaTqE++yDAB/@kroah.com>
In-Reply-To: <YZ4gjaTqE++yDAB/@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Nov 2021 17:48:14 +0530
Message-ID: <CA+G9fYsa=04=sKsxH2=5yh3NqGTZUpcD-4OiKcfiFGSH3DP+FQ@mail.gmail.com>
Subject: Re: qcom :apq8016-sbc.dtsi:412.21-414.5: ERROR (duplicate_label):
 /soc/codec: Duplicate label 'lpass_codec' on /soc/codec and /soc@0/codec
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Stephen Boyd <swboyd@chromium.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, 24 Nov 2021 at 16:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 24, 2021 at 03:30:09PM +0530, Naresh Kamboju wrote:
> > Regression found on arm64 gcc-11 builds
> > Following build warnings / errors reported on stable-rc 5.4.
> >
> > metadata:
> >     git_describe: v5.4.161-99-g60345e6d23ca
> >     git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >     git_short_log: 60345e6d23ca (\"Linux 5.4.162-rc1\")
> >     target_arch: arm64
> >     toolchain: gcc-11
> >
> > build error :
> > --------------
> > builds/linux/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi:412.21-414.5:
> > ERROR (duplicate_label): /soc/codec: Duplicate label 'lpass_codec' on
> > /soc/codec and /soc@0/codec
> > ERROR: Input tree has errors, aborting (use -f to force output)
> > make[3]: *** [scripts/Makefile.lib:285:
> > arch/arm64/boot/dts/qcom/apq8016-sbc.dtb] Error 2

> I can not figure out what commit caused this problem.  Any pointers
> would be appreciated...

The bisect tool pointed to,

b979ffa8bbd6e4c33df7f3e7ac3d63f2234c023c is the first bad commit
commit b979ffa8bbd6e4c33df7f3e7ac3d63f2234c023c
Author: Stephan Gerhold <stephan@gerhold.net>
Date:   Tue Sep 21 17:21:18 2021 +0200

    arm64: dts: qcom: msm8916: Add unit name for /soc node

    [ Upstream commit 7a62bfebc8c94bdb6eb8f54f49889dc6b5b79601 ]

    This fixes the following warning when building with W=1:
    Warning (unit_address_vs_reg): /soc: node has a reg or ranges property,
    but no unit name

    Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
    Reviewed-by: Stephen Boyd <swboyd@chromium.org>
    Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
    Link: https://lore.kernel.org/r/20210921152120.6710-1-stephan@gerhold.net
    Signed-off-by: Sasha Levin <sashal@kernel.org>

 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

- Naresh
