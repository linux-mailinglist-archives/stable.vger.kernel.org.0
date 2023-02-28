Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1266A5CA0
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 16:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjB1P6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 10:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjB1P6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 10:58:48 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A909214487
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 07:58:39 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-172a623ad9aso11316533fac.13
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 07:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6KMNq3Vvo7MwFPL70RNqzlYQxQGLWy3MDWWYpuGgh4=;
        b=Zsd4SfUCJZrMiXuB7kdf3dH6RN+k/kmQLTuIfajC96+UC0hRFbf7qFJVMfXYZBbvrr
         YTmezygLYttA66g7Y59V97aDGPYVQyicFPDGi2uhSfogEZP6R05OKS+WBupSummjGSdn
         gxZ+GMt3p85/XV/gwTjUWzjNxZAVrCvstguEuSLnCkQvZ4BtJTIfUGB6gdX26rxMhzjj
         EDh65H4RTTqT5Vjk3R3PddwEmbnlFNSNl3RIn+h8RJeDvAk6pANZ0e4NaX+PUbs35EsP
         hHADWCD/KUGMv023znaJm/fBHrymgiX0+NhUIoibf5XgH3aIOEfW661p9HE07XrlfFqh
         2Ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q6KMNq3Vvo7MwFPL70RNqzlYQxQGLWy3MDWWYpuGgh4=;
        b=ZyMbAFjZuBJdTc7cfce1ojZA5jnYzxvPyBmt9QPKQPnKpfe7BetjR7K0FXWzowPxw+
         qKIVPEgjO7y/fmBodrNKniujSW4QImkPTnSCdQdKXa+UNwzfJ6HWtdL4Lv0s34xpHL3A
         rrXqKOgXnq0XHjKNFrCgUiCmCEommmbppLiv1r9vE7OMAyuLZsNfBq+sx2dTbuFyyThU
         AX12PVwz3Ig2R0UutE+I0ChilCp6U+xFhra1GkSm1mufHiPKUPoyYu/WFhjs4uuuN6hL
         +HR2Vt6lKIIEeWknu8wMpKCpngQzGjKvQtHinuBzWcf8VaXYbZZOj8v2YV5QsjJhkcYd
         5JYg==
X-Gm-Message-State: AO0yUKVZVQh9gSIL5t9S6scvMCOE+zjIT7SACWwLa824gdPUMjThLKQO
        7hSTLxk1R8mO4MAvF/F9X6ylw2uIeFsyZiakhoucOhDf
X-Google-Smtp-Source: AK7set8lFN6mPegUzFEI7lTfRJII291Jq1n/8HMxr6iwGr5CIBrPhy2xXz8cEhmva2c3kjpz+7tXtRhnwjU0p9VgnF8=
X-Received: by 2002:a05:6870:3a05:b0:172:7c3b:615 with SMTP id
 du5-20020a0568703a0500b001727c3b0615mr889312oab.2.1677599917638; Tue, 28 Feb
 2023 07:58:37 -0800 (PST)
MIME-Version: 1.0
References: <f260225d-2a03-8d41-58d8-da278a790a95@arinc9.com>
In-Reply-To: <f260225d-2a03-8d41-58d8-da278a790a95@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Tue, 28 Feb 2023 16:58:25 +0100
Message-ID: <CAMhs-H-zGy3Nde_pUPE4aFJgg81+QH2NERo7yBkjQEwB2g3vDQ@mail.gmail.com>
Subject: Re: Please apply efbc7bd90f60 to 5.15
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     stable@vger.kernel.org, erkin.bozoglu@xeront.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Feb 11, 2023 at 4:55 PM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc=
9.com> wrote:
>
> commit efbc7bd90f60c71b8e786ee767952bc22fc3666d upstream.
>
> Please apply ("staging: mt7621-dts: change palmbus address to lower
> case") to 5.15. It solves the duplicate label error caused by the node
> name being uppercase on gbpc1.dts, but lowercase on mt7621.dtsi.
>
> drivers/staging/mt7621-dts/gbpc1.dts:22.28-26.4: ERROR
> (duplicate_label): /palmbus@1E000000: Duplicate label 'palmbus' on
> /palmbus@1E000000 and /palmbus@1e000000
> ERROR: Input tree has errors, aborting (use -f to force output)
>
> Ar=C4=B1n=C3=A7

It looks like this commit is not backported to 5.15 yet? I guess the
mail got lost somewhere...

Thanks,
    Sergio Paracuellos
