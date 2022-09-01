Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B81C5A9583
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 13:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiIALP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 07:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiIALPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 07:15:55 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ACC9AF82
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 04:15:54 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c131-20020a1c3589000000b003a84b160addso457877wma.2
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 04:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date;
        bh=/UVrmSBO/Ah16d2MZfS04mIdJZMZC82FdnBLfIfZvYY=;
        b=hlQv3y8lNdW5Z0g/lt5aY6Pg8EEldNAw4va3x5DQ5vzer/tPUuDJmP+6WYcKozy7G3
         7QTJArJpApdhpKDxP4MoAhdq+lKDT53lj8h7HMwc3DKBkgAkfa2+kKOxPfy/Oim3txa4
         rBMwMQB4wZZKIym430534FgQCBCmLQ75e1yoWQ8rQIIdah3NXOlIMFgQjz/rFcWdHcRc
         HAHFeLw8mWqIF4K0DAGXBn84UY1PwS3gga50wqCQtBm9Dq45TU1maXQHM1rVMgb7teRT
         HEV4JU95a4vFf//4YE/QGiwpzjUeTjMFQ2B+wWa5TRiuylwzjrYbDRBFizbeM/qeWGtQ
         VeLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/UVrmSBO/Ah16d2MZfS04mIdJZMZC82FdnBLfIfZvYY=;
        b=SL/zM7gnYf3ujikpzhHdRuMx2W80Kai5dLqo7tp4kz5RxJme7/TQU2cBBrEDSUGqFY
         1yXAumhPv3SnQ7VNJuvtacPbLfkMAWgNfd8pfJ/4V9SIenbWOzQDlq7CSrJtDdZXOOna
         5bKSKAn+HC9ghjVfmxKRZyTRBffxAVxO4TriSz1uTDITqUJFPu4u8iSnDMACHWNFj/Ar
         3k/dB3S6szc+ceNdwzKFvrdbP+uUTBPcB+/yBDuYE59ANSmUGSL33vQKL6B52gEWDyOx
         mhed/Um+8qh88kHOpKiRu6XILVI5MBpKPX1X+2dJGiQq/4TqBO4Fo175g3/esJxaidEd
         NBqQ==
X-Gm-Message-State: ACgBeo0MxUwSrND9fU3Fe7ZgsHY/Z0rXnbyFgxC/zUSeUheIs7qT648Z
        4/HX0NhclPAioNmc9K5iGXRJjQWktANJyZyuLHk=
X-Google-Smtp-Source: AA6agR6NzVSEXfCGojW/hg3Nfwrn8MmBV6DDjElS1hgg3i9bHCjd/R4seIEU1VRWUGRbPNPr8XHuJRfDNR9rTukdvxc=
X-Received: by 2002:a7b:cc90:0:b0:3a5:3899:7be1 with SMTP id
 p16-20020a7bcc90000000b003a538997be1mr4715270wma.19.1662030952789; Thu, 01
 Sep 2022 04:15:52 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkalamanthey@gmail.com
Sender: angelleangelle1234567890@gmail.com
Received: by 2002:a5d:584b:0:0:0:0:0 with HTTP; Thu, 1 Sep 2022 04:15:52 -0700 (PDT)
From:   kala manthey <sgtkalamanthey@gmail.com>
Date:   Thu, 1 Sep 2022 04:15:52 -0700
X-Google-Sender-Auth: SlQlvHr8GgWqYy1A1xu9dwgVCbs
Message-ID: <CAGT7zP2EZn9WeVs6mkaE_QpTOAoRTEVBqDxR+kq3FFwvHc_XEg@mail.gmail.com>
Subject: 
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

hallo, heb je mijn e-mails ontvangen? controleer en antwoord mij a.u.b.
