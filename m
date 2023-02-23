Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A776A0E52
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 18:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjBWRHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 12:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBWRHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 12:07:47 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E94DBE6;
        Thu, 23 Feb 2023 09:07:42 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id ay18so126205pfb.2;
        Thu, 23 Feb 2023 09:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wa/UzGyQDBMefYBiQESGpwhapQ4idUbLe6ID5walvV0=;
        b=HHa+hxiUtYH+XZPnVyEe9J1v5M9eo8BAz4RfQ/dT3ofq5PK5mIT2hMY+0S9ODdpzGT
         c/P2w7oBXBc4Rz6h1/qQyyU49q0EzluvqRfJ6fAYuh9Ltq+pV6lBPJI6WQ5kquf0J0WZ
         GYZV+4clHK2dZo8ra3dMBlbYimVopIeBmyn1ReqL0Lb6fhVzvgapFNb0O0eLeF3L9GPt
         Xm/AgQW2+mcACNXItRX6ZvnzHz7ApZe1cUd79v2Nx/vZxTcjvjURm/wqhloi5pyQZQMt
         +3P+0pBWVVvKJCnemUjSB89ksyqTjzY9arTOaaYgIPJ88ZxxlcLOmCE2vdSHpfoVFMZT
         Enpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wa/UzGyQDBMefYBiQESGpwhapQ4idUbLe6ID5walvV0=;
        b=HlCTQXUJuNOLASnzR6v+a3ynW5jcMHSRvruReAEDonHr0lsUExjbnPQNB4vD4Cvy0a
         PjbA4r/EzBvCqkShKlBsRHZDQEcadhXyInueID+G7e4AUZM9zIwgBfaeshYIP2K4RhgM
         kYv0tk0x6WKtUTLcDjJg4wRKIe6d2IjSnYEm7k+7nocbNPWBgqiqqbxW/WM68uQolAPn
         3phiL+RB/nRY41h+XgZsHv4jQzYRYq47Wm6OdqVO+UQQ8Q46YonmEqJuyGTUDWesCz1z
         pJuGw0UPFJKccVpVvw+zaoiAQqztJZTx0xZ3Ir3M6Unl/FsZHDlo1ewVUbK2TGGUw0hN
         2LVQ==
X-Gm-Message-State: AO0yUKV4j+hDETy3KvQRm9s7e0NlkV7exnJk2wLBrnNutcXTI2R6/zN1
        eGyuxc4Zt0At+3MKP3n24wx9G6bdy97gOwOSmas=
X-Google-Smtp-Source: AK7set8eYk9XZY9hlTLkfI6zqrLU2JHutM80UFVX+j0Nz7E+y8A+CDttLk8pNQEuY71QIVxCIQvjtAgqop2Yko1g7zI=
X-Received: by 2002:a62:86c8:0:b0:5a8:168b:4110 with SMTP id
 x191-20020a6286c8000000b005a8168b4110mr1951081pfd.3.1677172062027; Thu, 23
 Feb 2023 09:07:42 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7022:f8b:b0:5e:61ba:8807 with HTTP; Thu, 23 Feb 2023
 09:07:41 -0800 (PST)
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
References: <20230223141539.893173089@linuxfoundation.org>
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Thu, 23 Feb 2023 18:07:41 +0100
Message-ID: <CADo9pHgOp6hHC396k9yE4e1i=0U=_ca-tNtbYNd=Br0tzEWqqg@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        droidbittin@gmail.com
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Working on my Arch Linux Server with an i5-6400

Tested-by: Luna Jernberg <droidbittin@gmail.com>
