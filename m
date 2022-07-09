Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB856C852
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 11:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiGIJWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 05:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIJWp (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sat, 9 Jul 2022 05:22:45 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C537866ACA
        for <Stable@vger.kernel.org>; Sat,  9 Jul 2022 02:22:44 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b11so1321573eju.10
        for <Stable@vger.kernel.org>; Sat, 09 Jul 2022 02:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=TKvyPiNZ+anjmYa10tWJwFVa+LgbgMa6tcU0LfkkBNI=;
        b=MjIyKtZHzggzuiS1Zr9OImgLPqgFxGECrkbpv39QUBsZdzDdjg3YKaGCofbhe7P/G9
         ApgNxFYst6SE0Ldn3vxtXqzPMsVt4iHtoypCQZASF/PlMGTXFINmM7G+ryP6SJv/dhWn
         lgGtP8JAPA02HBHme3nXc+90Asd17f3HnTKH5HldyGSYrouukAF/IJzL0sI3BTmnAT1w
         qfEWhWgXCuNhby5bxaprVrSHjmLSo65e4kN89UsZRAlWEONzb/i20q6N/KiD4P2bQboI
         XaHIvGOMK9u2uTGxnGpRxORyzwTY7XD8uXDX6PGft9TG6mcbOnb0p0jtStv2Lha0Pks2
         2wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TKvyPiNZ+anjmYa10tWJwFVa+LgbgMa6tcU0LfkkBNI=;
        b=iZY2Eyr3kCu5G/QvWhkJyMHvnZI9qhIcXTBqKstV/RQzaQcs/bcS6M4R8f6WD8UmwR
         lMMUjax+MT+hVjDXF6yDI9aPbWlLNZdCteAvqaE1onYl7x/+KWQTeP9scnlzPxrhaOSr
         JigrPY5aqFi7bfFh4BgUCdXuwxA+Eyf/AdOqD3UHGeKzIzVO2uB9qV0eUWpSNGyuSx1J
         d0HpK65tYKMJVMNlLuWQhdm6iefsnlOmN8gFX4VsDu2UKr10ZoG1TLpj4IWQL5buMDHV
         mMul1jVXpc51ionCfgFGCpUAD1b+z+dS4Z11XTYNz1Qo8AdR+6uiiLiEUsykiydL7dmU
         DdOA==
X-Gm-Message-State: AJIora/EunBMAjBJ6VLvffij2RvZ+3qSCUT5DsDR2xfq4jCOqkBxLlE4
        oww/057vMFwfFTGwwdj2uAyYBQw6A79z+3p53LA=
X-Google-Smtp-Source: AGRyM1v7oM3upuqAsG/cN9QpNAvQCU3mqG/XAuTLKxDdr4vpjWW4Iw4hBAO5ZPRaOOCjQozUig4E5GwCXRWMA7ZLVJ0=
X-Received: by 2002:a17:907:a049:b0:72b:1432:5c4 with SMTP id
 gz9-20020a170907a04900b0072b143205c4mr8156024ejc.263.1657358563365; Sat, 09
 Jul 2022 02:22:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:a40c:0:0:0:0 with HTTP; Sat, 9 Jul 2022 02:22:42
 -0700 (PDT)
From:   John Jacob <jjacobvsusa@gmail.com>
Date:   Sat, 9 Jul 2022 12:22:42 +0300
Message-ID: <CAKZDKkBhVWY6dohkPuAnjQcDizFcFF08Ned+4hGtZdUNMvyxnQ@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Jacob John.
For,
Daniel Affum.
Reply to: danielaffum005@yahoo.com
