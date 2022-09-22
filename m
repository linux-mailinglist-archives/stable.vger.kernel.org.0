Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7965E6792
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiIVPvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiIVPvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:51:08 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DCAEEB6E;
        Thu, 22 Sep 2022 08:51:07 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id q26so10757726vsr.7;
        Thu, 22 Sep 2022 08:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yR/MpJ6iLaoqhtq3HaS5KyXpTOzBzWxV4Dzri8HB5fw=;
        b=bK6yaHIiH4BdIK7GVRQZJURHlLryl68TqPHx1ycctQoBzBIrSm+7jA6dci+xh/gTjS
         XkqGOvbXj5nz+v6XmDoXC9GlYW0aZ14/UFviwTfD8AQgF+C7Dn9eQWU2g9m+T2aAWhuX
         i8sbBBw614ZmYpORXQeNlWea+Iq+D6kZ7AMQtYwt0lg+6hd3IJkhw9Rh+xt0ddK4dQIQ
         Zgm8u23qGqK7zBjqc7X58ZNv3tJzZqKXrZFv9kDFvwPeZqT1pTAFBz6f33QLoTx6f1hb
         7xw6hLLDjglCV5kF1DAL9a0SWwI2wLdZDsubR25f4G4L0Goo0MXTKO+CirGMTvkbbtnX
         AHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yR/MpJ6iLaoqhtq3HaS5KyXpTOzBzWxV4Dzri8HB5fw=;
        b=Ygn/+EA1P72In8fL7Bk+wNS8LDtsu2VuYPWbAzPFmwpYPx6cKi2517znTjK7Vp1vCH
         bdtzny6nqDh2YAFv9JzGG/p1+nIW5Kk+jSYpW75UYuSxirub8e/kTUJhz1kIBNYUS76F
         aj6wUZFbYFNSdWJWy5MIuWE57rhEVaypyne9/rNTR1WkpBeoCeM0DeMkcfUBxIMjYEnT
         TzlY69us55i94HRZ0Zgc2xTxSrZ6I6oAR9zmkLYJKzOOP+0blZssLzEqzB3bSc66Jrfh
         p2r6nqaLonS/a/8i3JcHEgOXTOp1l9vO1wPBXICMi5bwM4kMMnKodmdk0xvxCVUqeAZD
         zKrQ==
X-Gm-Message-State: ACrzQf0R9/ckObY0t1z/tbXUnDtBvvNGb0v5h58Vpx/k6g5lfRv0/pzg
        yb8eaRoxcbG2I5RL03eb9BeTyaVlGdVC1my63Zo=
X-Google-Smtp-Source: AMsMyM6lArqY5Smn33t++qEIIrziuCzz63eMadYy/doqS+BYTgHpmy1YfNQaQ+WdMJ7RpjsN3tFIIpI4SJ2X68PNl6M=
X-Received: by 2002:a67:a247:0:b0:39a:c318:3484 with SMTP id
 t7-20020a67a247000000b0039ac3183484mr1598531vsh.2.1663861866434; Thu, 22 Sep
 2022 08:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220922151501.2297190-1-leah.rumancik@gmail.com>
In-Reply-To: <20220922151501.2297190-1-leah.rumancik@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 22 Sep 2022 18:50:54 +0300
Message-ID: <CAOQ4uxjDo+EWEOqpKpnZH3nHOmZJz3zYtae=GBrFEK1w03=xNA@mail.gmail.com>
Subject: Re: [PATCH 5.15 v2 0/3] xfs stable candidate patches (part 5)
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
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

On Thu, Sep 22, 2022 at 6:15 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
>
> Hi Greg,
>
> These patches correspond to the last two patches from the 5.10 series
> [1]. These patches were postponed for 5.10 until they were tested on
> 5.15. I have tested these on 5.15 (40 runs of the auto group x 4
> configs).

Re-posted the 5.10 patches.

Thanks!
Amir.
