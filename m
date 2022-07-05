Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB4F5675C8
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 19:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiGERbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 13:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiGERbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 13:31:14 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738BB10F7
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 10:31:13 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z21so21679123lfb.12
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 10:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=gso3aOYb3abj7ySntXYgQAUKK9YI7eKoplhwHJfl/jrLDBsVCWklzxu6hmq0foOhnX
         WD8wLvoOALDkY7+fivY0sVllLJPNYRmdAv7QSiFRHKLDR9q2lTtNFJL/5uEYzUkuRG6V
         AwP1WNZnyxag80RScfMDBplsFg91GUDIYLWU59CHmBUZXzXNF35Q/kbbsBhopG4wElw/
         yFrUWPU5y0BRf9xMF3VDKstHf52/YB/TGAMs16vBftaEKBHxSuhr0KrVuoABm0toEAob
         u5NbIupGJHy0bEwKzXr/DYfMvtjPuWawPdzEb2aoXfLuHakFHiulQLt4yaC1deBT8plN
         fDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=N7N7ZnRavQLhIPg6EALGwdn3apCTH7MuFevgY4n4YyTiXBYzvqIp7ml7L0mX4ioR7x
         8mAvnFuHvkumzduqRmJ/WC3zQAke5pftvo8sfSAYIu6wXw3Ie1p6bZ3tItCfClxo2DAQ
         nbg/2RejpiYHkltHnbt6XqkMzD5zNh6ft81X7k6jCBDcF0E20aAjINY5o8EN+hLtY5ZJ
         xwflJI2vXm4VlFmVHcFdFHkG6BkHCbWPmGUAikyDpyq+aAm3XH0nLD01ItI6SW9OVeRh
         nELFVXfBCMl/Na2wc86QYEHYin6b0jOh0wEj8s3ThxF4OBNdje1BgUxUib0by5CqX1Xt
         kS5Q==
X-Gm-Message-State: AJIora8kgPg/hm4+vM03epcmNd4IvuJZ/9jT4keuKXDtxrDGhi0faEeQ
        Fb9SeW5nJRBo3sMh5f9GnYQ23+xv39dom61bMzMKGKp59sAYpg==
X-Google-Smtp-Source: AGRyM1tTQU47IQC7n//mAwdP1QC5S7s/4BuVu+kRcOgIOCKa0h/HFYGofmjDLAjR2enEpVV3Hb/NJtAFLKMQA33M3JU=
X-Received: by 2002:a05:6512:150e:b0:481:60af:a5a5 with SMTP id
 bq14-20020a056512150e00b0048160afa5a5mr15512233lfb.524.1657042271620; Tue, 05
 Jul 2022 10:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115618.410217782@linuxfoundation.org>
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 5 Jul 2022 23:01:00 +0530
Message-ID: <CAHokDB=Ma1Diu_0-3Hwq=TV2pGM=uOGVdgS1d0uYrXxUQpvQ6Q@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain <fkjainco@gmail.com>
