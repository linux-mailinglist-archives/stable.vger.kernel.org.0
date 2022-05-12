Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9FD52514D
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 17:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbiELPa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 11:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355646AbiELPa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 11:30:29 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EC4994CB
        for <stable@vger.kernel.org>; Thu, 12 May 2022 08:30:28 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id q2so5549524vsr.5
        for <stable@vger.kernel.org>; Thu, 12 May 2022 08:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=OGjovOLLCNX5QV/XTVfdAcAkHFV5TFmZScvINXsyNcw=;
        b=VW8JGIJuwO2+Hy5FY5ZYnO/iXPiB1Glr7x4a9PQE3mg89fbqbqp6qe1Pz6eVNFg9KG
         jH+um2tVLFP19Cgz9bHmmL1/zLknO4ETrTRyor7GZfmX2yTcrMzL/xKDyL2xHl7PWz6Z
         XBWloKepVvKiwa2/Es52RaVxtZ2XwMQENjrvvg695jcgY8fl5swlB/Ailn6GhSQRVYEv
         6+3ppgqDTboiJ2GCjL1/rbjrhoQgTnjZ2ql6dKNWhTlnYy3SBO7fwUS8i//TsTGYr7rO
         iPQMWoyJXim12/EnaR+EFB94FHQvi0GZ8h+v8cZ56gb6qeuNlre+rh6Vm2RNX2s5fba5
         V0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=OGjovOLLCNX5QV/XTVfdAcAkHFV5TFmZScvINXsyNcw=;
        b=hS6MiM5//Qv8XpQOwyySHjrcsL5pUflQixYpozwmSX6vc8vLFs8Iws9cnLghytkXWo
         uQUUt7rSasEFmkg7WYDVCGak/XfDleiTG9bnQBaXwP07sqpvnHZLnOnOOnvMksZ8hGK0
         hKzieASHFquz8S+ie8M18/WNulhhs6TUGVIDlvs9HbAwdZJe86QCAV2QxOsOcFJqlkjI
         5SZntqP1FyXGwlNdo/QrsrZ0c23KLvyZz8zdXq9dDXqn0APi7SdsnpoB/PWCmFAifaFg
         2JuG86hvQsYIf3YkMcBvQ2yiuzg0JA5t3u/0Yucz6dnXfdlDl68ykT956YwmYftawPMe
         +P0w==
X-Gm-Message-State: AOAM531HjhPqcwXjVROSsf51gt6fw3ijIPQ9WR0ujMKj/J5t4hmqJ3Wj
        vNTjuRWTgDxI+Vv7hG+C9hF31H4EhnBQh/hPzs8=
X-Google-Smtp-Source: ABdhPJwYP2vP9240D+11ybumDCqsfa7mNch7cD1GA/IcvCgSjvp+Fblifl0JGvcDlxT9GsBlYs9F3mnUprSR3blYnF0=
X-Received: by 2002:a05:6102:226c:b0:333:c0e7:77ea with SMTP id
 v12-20020a056102226c00b00333c0e777eamr441440vsd.16.1652369426610; Thu, 12 May
 2022 08:30:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a67:4302:0:0:0:0:0 with HTTP; Thu, 12 May 2022 08:30:25
 -0700 (PDT)
Reply-To: rolandnyemih200@gmail.com
From:   Rowland Nyemih <guedjouirene@gmail.com>
Date:   Thu, 12 May 2022 16:30:25 +0100
Message-ID: <CACrAO7Ber+jeHXWNqmsY7cXH7cgFnMz0is9N7Q-kE69jQdC74A@mail.gmail.com>
Subject: Rowland N.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e29 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4981]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [guedjouirene[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [rolandnyemih200[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

HI,
Good day.
Kindly confirm to me if this is your correct email Address and get
back to me for our interest.
Sincerely,
Rowland
