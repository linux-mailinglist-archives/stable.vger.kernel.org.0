Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16BD59FD0E
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 16:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbiHXORF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 10:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239156AbiHXORD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 10:17:03 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D539924B
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:17:00 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-334dc616f86so463726297b3.8
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=pwWMY1mQoDhD9826rWyoQIo0MVaX6kxuCqbALte+/Dw=;
        b=TTWAw96EMqdCEUa4b0Ey7pV0/ozeU6rTFgX9lbPoak6BppTmyGBpmhT8AOyHeRQeZE
         9ik+GL01et3i6OfUmv9DKjKdx1EKRtUKMgumYaSOkYDJ1X+ryBpIZrJKNcI4u0yhTukk
         pyQRnsaJ6qv2BYlAqtab7ROrErTI3Mv17PECEi0NTxDurlcEBRqrKlWir4lrHhQE+BVx
         oG6OOWyWcOQ5i2P012nmgUu2CJE2EAQgB5mB0I5TM772F9567X2i5DraKKsbzKqPeZ79
         IcFL6iRAW086ld0yIFcKsWKdYK975TmU+RdrlF5Q7qLfcR6c8RFCuvHWOyQEdbac7+oG
         OGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=pwWMY1mQoDhD9826rWyoQIo0MVaX6kxuCqbALte+/Dw=;
        b=vjn6Bdm4sEkGWx7sO6skjh3o3etomySuw9V1K0nfKBtPL5C5WGTkQsd3g5hWR/uk9N
         laLCo3RiNqFqCXaZr3DHylyzE8EinGOwlja3UgZj6+ojKjJFLM/Gq6OTBa+mQk/eZ9Z6
         bsKainejCEH59LDPQLCVWpPDmop+I8Q5kpK14RRh4Lz5BRl8flHwhGtpgkOythPucGR+
         htVCMWYyyoMlWm4dWm4V1WKeNxNr1GPLlyKIw491diUUbHz+Vh6X9zoYL7tV03c86J1y
         iK03mAOpYdgQjlcxoF1d5D+yq/TNK50peFN6fXg2cW+sdxvP+F4Cemq44UM1MvDEd+9m
         tWig==
X-Gm-Message-State: ACgBeo3AuQ8cA09IQXKDNJ22zJ3zYnO9OuJIls3B5DyTj8ruf+RrrsMZ
        dn0sqYGQSLXnPNNJKCirkbfie6Ti5zTYBPslUA==
X-Google-Smtp-Source: AA6agR4mRiv2GIpmr66OxjEACOaYszQ6q3p8zHscnq7L8XmGBocRwtPqMtCis8ed6qaCSUrqaI1ci/+b+vfxjiwBK38=
X-Received: by 2002:a81:4b8a:0:b0:333:7729:5b61 with SMTP id
 y132-20020a814b8a000000b0033377295b61mr30855898ywa.240.1661350618962; Wed, 24
 Aug 2022 07:16:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a81:9f0e:0:0:0:0:0 with HTTP; Wed, 24 Aug 2022 07:16:58
 -0700 (PDT)
Reply-To: mosesrichard499@gmail.com
From:   "Mr. Richard Moses" <johnsonbobolo8@gmail.com>
Date:   Wed, 24 Aug 2022 07:16:58 -0700
Message-ID: <CAGeDCtEXi+ZarTsHvDZJyr1Lj7u51XzCjD-dJVN2somDMSZvRQ@mail.gmail.com>
Subject: Mr Richard Moses,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1130 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [johnsonbobolo8[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mosesrichard499[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [johnsonbobolo8[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello dear,

I am contacting you again further to my previous email which you never
responded to. Please reconfirm to me if you are still using this email
address. However, I apologize for any inconvenience.

I await your swift response.
