Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684046B0C05
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 16:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCHPAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 10:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCHPAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 10:00:53 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B524C11
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 07:00:52 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso1533871wmb.0
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 07:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678287651;
        h=content-transfer-encoding:subject:to:mime-version:from:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=km8AYClsgRL+l4X0k1bSrfqh+593Y4aFlyz7FmefBDA=;
        b=ZYcAvGwqW25QswuZ3iFuE4DDpk+agYIhO9Dlr+G/Q3zhkiziX9GJHWoderIwR+Rjlq
         KwqEsD2nLsRgn+MzCuL3tCXWxUCH8mGorLywz5bp5cqUcFwPMAHtKnPDUz99LoeEhc8z
         MEWCEyqX6Kt4MyQnW//bZ53k4VlQXEm3fsWnHu3ch3+XwHnciChHXkzH4TH9wPFidaH6
         NwyuLjz/kib+HRzjU/2Ln1XHIX5zCuPUf/0X7Ha2VGT1no9zQ97l+5MjaLOGLQnxvzV5
         oc3I+lLzvuzcypiRGc6ENZhUet9U+46fSkiFBQrEOUKXNMzX0+VBUuxuuOpcVLAfzb4F
         euxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678287651;
        h=content-transfer-encoding:subject:to:mime-version:from:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=km8AYClsgRL+l4X0k1bSrfqh+593Y4aFlyz7FmefBDA=;
        b=bmTvgcZ9XZG277arA6jr6sAoP44iNaJr0G5y5GiHL8wnUwydfjeAB1iRxBYvCVaAgM
         3BqKNTE17jEbMqZjbxxp4EFTT9xIzsCBJMdLG8CqXWoCx1F3KeNXyn2RKn/TKeR2c7M0
         6j6g+WkgRuL8A+OLhXS8ImhKdBb9PkggaCViVrfvxiSz5q+qBcqztRMcKnv7yl24ajEU
         nBNrUy1Ah6eAIdpkR726hzAaScrN0IrquUnxsr5Xx62sMFH1gyinuuxaw6kv876bBcW1
         ODTqKlhvvLMxbYTdCk8Dwq3ePWZAPKtAApxSHHKkjgDJm8LLpNOeMyv7y+bgwHJGNZ1R
         1mJg==
X-Gm-Message-State: AO0yUKWibv3ZnBaifr38tiC59W+6Vts/X2JKw41drwWsaAaWMft2Tqn2
        Ck4BS4Lao+/t6Yl4NGt+JdsaetQYd70=
X-Google-Smtp-Source: AK7set9aFQ2ppnhjrTL4x/lAw4/7AgmXKSMEeuCwOX0/7R5tARwkyP1KzZoZrWZJAXMLNmy+dQCGFg==
X-Received: by 2002:a05:600c:4f8f:b0:3e2:1d3d:ec41 with SMTP id n15-20020a05600c4f8f00b003e21d3dec41mr12710395wmq.20.1678287650851;
        Wed, 08 Mar 2023 07:00:50 -0800 (PST)
Received: from DESKTOP-8VK398V ([125.62.90.127])
        by smtp.gmail.com with ESMTPSA id n16-20020a5d67d0000000b002c758fe9689sm15489889wrw.52.2023.03.08.07.00.50
        for <stable@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 08 Mar 2023 07:00:50 -0800 (PST)
Message-ID: <6408a322.5d0a0220.62ddb.f17b@mx.google.com>
Date:   Wed, 08 Mar 2023 07:00:50 -0800 (PST)
X-Google-Original-Date: 8 Mar 2023 20:00:50 +0500
From:   amosjace274@gmail.com
X-Google-Original-From: AmosJace274@gmail.com
MIME-Version: 1.0
To:     stable@vger.kernel.org
Subject: Bid Estimate
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,=0D=0A=0D=0AWe provide accurate material take-offs and cost=
 estimates at low cost and with fast turnaround. Our team of prof=
essionals has been providing these services to General Contractor=
s, Subs (Painting, Electrical, Plumbing, Roofing, Drywall, Tile a=
nd Framing etc.). We offer both Residential and Commercial Estima=
tes and we cover every trade that you wish to bid, whether you wo=
rk with CSI Divisions or your unique classification. We use the l=
atest estimating software backed up by professionals with over a =
decade of experience.=0D=0A=0D=0AWe are giving almost 25% Discoun=
t on the first estimate.=0D=0A=0D=0APlease send us the plans or l=
inks to any FTP site so that we can review the plans and submit y=
ou a very economical quote.=0D=0A=0D=0ABest Regards.=0D=0A Amos j=
ace=0D=0AMarketing Manager=0D=0ACrown Estimation, LLC=0D=0A

