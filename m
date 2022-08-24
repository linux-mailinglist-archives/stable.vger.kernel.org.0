Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9E759FF0F
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 18:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiHXQEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 12:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239195AbiHXQEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 12:04:36 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167277D1F8
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 09:04:36 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id q67so9295118vsa.1
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 09:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc;
        bh=zopMFpFAJ5LOC8HL08QG7sc4qZEuFv8cLIrgFdSEmLQ=;
        b=Ghf9ldoGIigOPPvQ8ICfg9fA8XZvQMmzKg+5BkrmjcXql7jByU+U9IO5N89M2iS4ka
         56CU0NB2wXI4kxoeoXqTlNTHOUABYg2Uv4aYERARPzYZOlTMJi7e2Mfoke+zo6xqvnu4
         aAbpgUL9tc6mmIeuDkjyNO2TqKme1hwyl8a9DB61JCRyPDvWD5YXRAvSczPgY5VURlEZ
         WpURLl61egQpOZBYtEJBkNMXAou09U0Wut292UPCI/xZv7QmjmowijRUdAvk2RwAbIdz
         MUTmVadLNnkJvzYUyU1IPTUqqZKoQFcxoyE2CaX7mCB/KDWfLU5G+q+4ZXbcugr+CmuS
         0eXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc;
        bh=zopMFpFAJ5LOC8HL08QG7sc4qZEuFv8cLIrgFdSEmLQ=;
        b=IDSjOE65AaLPcH9V5xVqBUpiEQwTPKw0b/oVv/gZ0wGHqV8t7iSMqGkOyJDNGqdXkA
         u27hAYEyfj7o5hdbFXXgwLLDRYdMO1BgIsTc6GXmqtxoM5ciKdk+9DSODQfQgRsY1Pv4
         EUuq2G428v9PkkP1nFcPlL5kOE2MCkI2oHlJSGf7tgZSIjx1KV7/StOkYKVbkpiBF3k+
         /hiTh8f2FgLhE2pMrfJVu75lZEtyqwBG4WFooVR1bOXcw/QtBAle5J3bZNvCUl4/paid
         PZaesk3/dTDyvvRUUr7Ia2a1aEcCSgWcQLbwxXIIaQYV/cmklrBieYcbgTvHL4s13DHY
         W/9A==
X-Gm-Message-State: ACgBeo2jwaO3apWLb/1S9c4C37p4bd6QKA4AEzqQT2jAC7Y9MgCEvQ1G
        azIiMyPuoP5E72fB70F18ws3VtSZcYAmP/8WEBU=
X-Google-Smtp-Source: AA6agR6J/9ndqrltjSFHpVWz+8VP7HYq2dmkUQpdJca9DDNYQG+rMtHuv0RZAmwljxx2bd1awjIt9CyK/Y70ekBRixY=
X-Received: by 2002:a67:f552:0:b0:390:4d84:9382 with SMTP id
 z18-20020a67f552000000b003904d849382mr7086337vsn.30.1661357075224; Wed, 24
 Aug 2022 09:04:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: friquismerveil@gmail.com
Received: by 2002:a59:b7e5:0:b0:2dd:f9a2:a653 with HTTP; Wed, 24 Aug 2022
 09:04:34 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Wed, 24 Aug 2022 16:04:34 +0000
X-Google-Sender-Auth: KFlt09Vw8APhpctcb37DpplqMBU
Message-ID: <CAP86KsCqdQbutJvhasQ9WOxn28mcGRegcZzFcr55TeEVMW+QZg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dobr=C3=BD de=C5=88, dostali ste moje dve predch=C3=A1dzaj=C3=BAce spr=C3=
=A1vy? pros=C3=ADm
skontrolujte a odpovedzte mi
