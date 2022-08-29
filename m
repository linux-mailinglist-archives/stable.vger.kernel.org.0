Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491645A53AE
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 20:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiH2SCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 14:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiH2SCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 14:02:19 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A937E82A
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 11:02:17 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k6-20020a05600c1c8600b003a54ecc62f6so4844428wms.5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 11:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=mfvLvNFtdnwDqd4RIN4u7mHxBxxWdcl6Su8NymYNCWs=;
        b=gfFxucJLX5fvuLiAUzUSQuaWWSDOGihWPP1WLTOLns60YnA3uONu8Lt+pD/sWgM4f2
         gVDICYVCRFNVYyeyQSTe1QntuYNUBas0KjaSgoBuTj0zJl5YC++Pvpcr01HPawmd6Wfb
         JJjLUOGyZkeGZm9fOL2x/LDVssHVBUuyb9JOsyVZb+SDDH6+8WzSsTeVayoO1hhYZisQ
         9JIXe6ZBAiBf888UXAAXY/+iqg+/iDHwgmzVWewzfZB84sw4vWi5/PSvxw8qvmRuZoxC
         1q08puLNJASX3ChQsawFLGpUOXBdzrkN/+YHFSM73sJCROjA7W54DG2Fev8/azGf7+/o
         0jYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=mfvLvNFtdnwDqd4RIN4u7mHxBxxWdcl6Su8NymYNCWs=;
        b=VSxkiskrDgW+7cMqw1f7Et1Z/lgBAw1dtIwD7XHxYz631TPdcOEEHtqi1OnJZReABW
         GurmQijyINk1d5gVRhF1Akag209CmlQ5OCxUtJI96iPkbasTrVVqH6Ka2lN9xyvGrtyA
         OIJAiD+lQAjOo9+O3pH3bByyIovBNKhYYDc7OXWgWj5vH5Ls1jsoWJYbvTXDqBrSTrZN
         gnbCHur8qnoNMgel6JA4xh2pFtu5mQRura1CVJNCJOM/HEbEMicjgPG/60xH+6HPIwYL
         dWF5qcUuwkm82s/KNH+oI4OwuPxl0iVtesnN/3aWVuzPHyRqXCGqnmONslwpvSieWJ0H
         3TkQ==
X-Gm-Message-State: ACgBeo2k4IagCBAIqbjOsqhfdiPF2fAk6y+NdBDVnwRFthjGKAolD7R8
        WCv4/Auo6OjQMTu/dpEzfDu1Mx+wqJrlA3NDDkg=
X-Google-Smtp-Source: AA6agR7NTUuiEGlLfITKCB41pv3PZ/oh7JbZje4AAwfjxsZsLu0EgDRkzcfvidV8dAO+63yu52W5M+N1nU/bKITMjsE=
X-Received: by 2002:a05:600c:4e92:b0:3a5:fd90:24e3 with SMTP id
 f18-20020a05600c4e9200b003a5fd9024e3mr7653809wmq.59.1661796135891; Mon, 29
 Aug 2022 11:02:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6021:210b:b0:1f1:df49:3e95 with HTTP; Mon, 29 Aug 2022
 11:02:15 -0700 (PDT)
Reply-To: mauricepeace537@gmail.com
From:   maurice peace <echichi546@gmail.com>
Date:   Mon, 29 Aug 2022 18:02:15 +0000
Message-ID: <CAMjgLekUg6FFwd_B_CTnC2DKngNyi_1Sg=MZJbaMW7wAcMakpw@mail.gmail.com>
Subject: Hallo
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:333 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4953]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [echichi546[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [echichi546[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mauricepeace537[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prosim, mu=C5=BEeme mluvit?
Neco se pr=C3=A1ve objevilo a je to velmi nal=C3=A9hav=C3=A9, pros=C3=ADm, =
potrebuji va=C5=A1i pozornost.

pozdravy
Mir Maurice.
