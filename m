Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07BF653738
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 20:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLUTvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 14:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLUTvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 14:51:42 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D79A1DF1C
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 11:51:41 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1447c7aa004so20406317fac.11
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 11:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V+7RlKU4oHv9cX/BhfmWye51SNkqvV50b6925OJ4c/I=;
        b=IgoGMQAiiJ6wu6/xG+To4awaoguvfXhA+TtTPUxIU0TkGu6lmSnM93Y2gndAv27jlF
         R5nImrbMMIAFXj38WUBKf3h69X9ZCDmlh+2o3dcII0Cd8/0oeR8a/UPNZ4sEW4pUNGnk
         ugkIMSYCvj7axMj+V2tcmTQ9a45KoEwWogOyNKHfL1UNUIM/JNqfFoeQkVoXdaay+n6h
         KEfoIbbGOR78QyW3T3OuM96hWTqYl1a/JAXeclfHXa7q3P/wdaLiiglNG65Knd5UXmZe
         MPcDRYemot/RWCVabxAJk+GdeOITwHxLvODrshz5/aPiiVoHWyl/SOXGmREql7csqo/5
         dDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V+7RlKU4oHv9cX/BhfmWye51SNkqvV50b6925OJ4c/I=;
        b=2f2DuggT/wAivQeTylHaMIyw0v+WByXcmeSJ5vSiXo3Z4ZjRfiB5DM+cug+52WTOCf
         OEyIhmvaMxYmHQUsvXdT655gimLq7rkBaksTx3fJOAbvjuchLwLHzED71lDPadtcwcCZ
         eZQmsyCaaSAebZM+ynQ9alQZkcBir2CCOWo+dkMaoUHYB01NjMSNzEDgfGNfnMIsGtG2
         ef48lLeJE8ssRBegMIITxgHO+uqkDxzjKhbyHd58dkxaphoxP1x4m8NXw+OH9lDRBVRP
         m0zZPTrM12DanZt7E7L+rkvRVRi4qzhpYLKJJqzIBstSPSPjAWPkyYhnT/Dz4oD0Inl5
         1zBA==
X-Gm-Message-State: AFqh2krqDMBxdq4yeTYC5K3tKIGJ8GVVfBLrM5OHkR0RwG5e7uRnnTAc
        pjdrp/5RBRLFr58WxdMf1insHNa0I2bUt3LBsoQ=
X-Google-Smtp-Source: AMrXdXtuJmsxfPDWMc5VfT1Ndr230JgoY+s/99uNjseaQsEAGq33NETZdDog+4gfIwmesjNZZ1MRF0gcm4uhSBCX4Wg=
X-Received: by 2002:a05:6870:4c03:b0:144:8004:1b42 with SMTP id
 pk3-20020a0568704c0300b0014480041b42mr301824oab.105.1671652300899; Wed, 21
 Dec 2022 11:51:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:1203:b0:dd:2d6c:7c41 with HTTP; Wed, 21 Dec 2022
 11:51:40 -0800 (PST)
Reply-To: cliffwebster92@zohomail.com
From:   Cliff Webster <habibaalfa33@gmail.com>
Date:   Wed, 21 Dec 2022 20:51:40 +0100
Message-ID: <CAHVc5rF5MwcUEjKxN7Z0B2x_x2zS05x6EnOe9zMUwYkaCsf3Vw@mail.gmail.com>
Subject: Payment invoice
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 

Did you receive the payment invoice already?
