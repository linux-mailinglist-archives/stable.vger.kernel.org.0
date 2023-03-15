Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13BA6BB5F2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjCOO1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjCOO1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:27:07 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B473A877
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:26:56 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so2181907pjt.5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rethinkbizservice-com.20210112.gappssmtp.com; s=20210112; t=1678890415;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QRGDcFJIGBma9Zz9WPLV+B8Swr+BpfEp6IuOgMtw1QM=;
        b=yJLogEMwQfARAHOJsCQ9sR3kigYgdrDAng2JiTbJgsUB1OTeXTvfUlAZ7TCVCckud/
         Zcs3a5IQqIfEaBkdOvTlE3JKGEbR022s8PhBk9jQ3tkmg06sWaAUBklM2MqRo+YbNcly
         LX9YwrQZNzDpZLmWkngMk3h8G1LOi91dsGtZ6xfGogzlbg3d6L7fabeQwFXjqyQuyVCB
         l9Xm2Yr53srds5kPftyJAesVoDSpn410L5IQSyedS4V4A5uXRWCRZcXha1RIgPjZVrNf
         mlkGbo8+zW6RMz4BbYh5H+/i6YHqJtrHqTqNZg1mftT3GXxog1YuQypyk1M0+GKb3IzA
         o8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678890415;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QRGDcFJIGBma9Zz9WPLV+B8Swr+BpfEp6IuOgMtw1QM=;
        b=YahYwNPZUBqOPS1MVeCNKVA1ymLjNGYRQrM0o5qA8aFl62eEbPFs12RL3gbUaPtBE3
         a37BcoSvvx0Uw/GiQvrj9JPO7acYnK5zsekNXdeL9Ivf0HptOKwjBvszgKQT45/7e+PA
         FkRB5H+ojYBuilHPQ3M9PtUQffpo71X/6RQf8rvTF6GjT1uxFt4gqDz+EBb3V9AnfoTX
         hlx7sxKMXj5qTcIKglx50V2fEhZxVc3yum0KR1tbLeYEn/YdckC2UpELMejcE7DhG7kZ
         EYmG4D9Xp3QCNQV9eTewI25V9WmCqCNUZHo+iGA2O2cPxZZ94fTrsjmGv2ypP07Dzdy6
         fwFQ==
X-Gm-Message-State: AO0yUKXciSTTMD92ydpLHJJfAD43kE+P4sSH1hlYttHk6vYoIjxBrmtH
        I0txolzB3gQjxoS3q3thr8icOrl2ZZ7+HDaAq8JR4w==
X-Google-Smtp-Source: AK7set9qlvB8y/jnTsWwbjew7U8Y36sRzMWYWUPupu3iVkQVcKoiA9lBFQgoeot75TmCd5CNYN91Tu8CY/Q+/EsRC54=
X-Received: by 2002:a17:903:482:b0:19c:d14b:ee20 with SMTP id
 jj2-20020a170903048200b0019cd14bee20mr1237214plb.8.1678890415609; Wed, 15 Mar
 2023 07:26:55 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Taylor <adam@rethinkbizservice.com>
Date:   Wed, 15 Mar 2023 09:26:44 -0500
Message-ID: <CAG5wPR4VD9=URdOuU-sdB4F+ai_uBujzmjRsabXw+ftwqugoaw@mail.gmail.com>
Subject: RE: Healthcare Information and Management Systems Society- 2023
To:     Adam Taylor <adam@rethinkbizservice.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Would you be interested in acquiring The Healthcare Information and
Management Systems Society Attendees Data List 2023?

You'll get access to 43,386 opt-in contacts, including their
organization name, first and last name, contact job title, verified
email address, website URL, mailing address, phone number, fax number,
industry, and much more.

No of Contacts:- 43,523
Cost: $2,289

Contact us today to purchase The Healthcare Information and Management
Systems Society Attendees Data List or for more information.

Best regards,
Adam Taylor
