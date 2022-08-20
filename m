Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A983B59A9F5
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 02:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiHTASU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 20:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbiHTAST (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 20:18:19 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EEF18E1A
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:18:18 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id l5so4481063qtv.4
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=jjsFN5ISYSnx6H35iHMNnOYtx+vdE82LGa3G02O/Byw=;
        b=CzwUp3AD4Pln1wKGHuIzgcVxvfdG1KnDa1Me1i0k5DpQylis1Ch/65/DEUFaXmDhl3
         g2MW6/MhUJ47cJ00R5bWpf1b97LiYiidUKm9MJlLFgZQEKelfoEGNFmzijn7v+cRhMZ4
         BAetNJEFZkF2z5gOzojKv1gbPuuQ6x5iUXCWlpqsJ8hGJBPsklkW30LLehtlG+DBQRty
         SBDXKMIKzQr3fv9H3/cTavapy9feb3MUfE2Nw7fmNsdkSueIaNdw14nU5L98eduhcFZl
         Kg8Bbt5A9WNJOqwsqkhKr0Ec8bQ1ULuWAdGdyzCqOpyvFF+kmI5Y9w/FR4Br1J7oUkyB
         NJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=jjsFN5ISYSnx6H35iHMNnOYtx+vdE82LGa3G02O/Byw=;
        b=WWf68YiV3SWmlwuF6xQ1YHLI1Qr00UzhS1DWZqbgPoVLeM63iyObzN32RSr2bLMxOR
         qKXuxY1lrGcBATBizVT30LHQJKM+STWVv1F+ttolPxQjpEUl4t08QB0UhghboWBGjyiC
         mxKnMZ0z53ATLDYhZG0fZ+QvLn1QCQVuBG8Tl+GtOwceS2Lw2kiOeYK+vCWnDMZ9fiet
         6Ca/gSqqfC4p7WJtoQcjI7DiQLBRWick7jxIkUKB9Pk8ySlL+aXTfxeGq5jQV9WI7IxK
         Dc/BmT5MRrJE7aS1wwOmsWgKHN21RPxonP2wZG7g+ndYsrpdlp3cJ0iXL+ZPfIiS9TQK
         i8dw==
X-Gm-Message-State: ACgBeo2bGs3MQVwNMPgXlDc0u2nm7rusiRL1NupnPNc43+459DulpiAn
        JEDr7hgJ6fgsFTvMDgJ/MK0XOlrwigljTNlnY2U=
X-Google-Smtp-Source: AA6agR6Ec67VZfwAcBSrdbfDl15wNkhoab90ckYkdVAIFSmxWfI7eeVSfj+vlc/TxhuwxyRRgiJiFyUTFWmchyCjGNg=
X-Received: by 2002:ac8:5c4f:0:b0:344:6df6:a237 with SMTP id
 j15-20020ac85c4f000000b003446df6a237mr8457417qtj.242.1660954697222; Fri, 19
 Aug 2022 17:18:17 -0700 (PDT)
MIME-Version: 1.0
Sender: falaismael56@gmail.com
Received: by 2002:a05:620a:318f:0:0:0:0 with HTTP; Fri, 19 Aug 2022 17:18:16
 -0700 (PDT)
From:   Jessica Daniel <jessicadaniel7833@gmail.com>
Date:   Sat, 20 Aug 2022 00:18:16 +0000
X-Google-Sender-Auth: jzXQ5RNufmedEVpOI8I7wcn3fVg
Message-ID: <CAGdet089LFT=1p63hGkiptuFE-Xa5Q_NvrKSsFfegrAygUD5yQ@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 


Hello Dear,
Did you receive my mail
thanks??
