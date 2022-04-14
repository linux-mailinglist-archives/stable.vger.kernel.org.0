Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37402500C33
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbiDNLd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 07:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242521AbiDNLdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 07:33:24 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F2B46644
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 04:31:00 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-ddfa38f1c1so4916629fac.11
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 04:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=vaY/RoiscDUarR8YBnnznQCCP8p66prv48I5vyLB6iE=;
        b=JXHjccOaxvXcNZYsJ3yHcQUqFM3I1mVKobGaHh8aLYl2Vy6dMQCbXKDTTZVsUmKsLC
         eexnDkNU3xxvQ7+ZJYWGVLNk8KmGIuPjjN7yyrD8V4EE8upwh7XdL8n7KIu+16F8nCew
         pDxVN1phxzUBntGlydSiqyYoHechQ290y2z/vsHbPNryglGoO8pa0jS++nkTRIAT8FiA
         4fY84MzyPPtxr/zCavLSFAboT2De9muOf7zZ8Ig33B/7HZM5afxGQj3XywkmfM33E4Qv
         zziIqakEud1lmwg5teh357gKo0sOGwOAeJfO9W62Olxxb8CZ7yfIvz/EHD3etL+3i+PM
         w0ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=vaY/RoiscDUarR8YBnnznQCCP8p66prv48I5vyLB6iE=;
        b=mAoYCY+t2jgBx4gP3p3fRiFHePs97oPEkzo12nY1TGIGeDcCUy8IAAgny7TiXYltuI
         uR8ok0byxPf7x1rJB4s8lGEWKJKRutSF+N6sujn0ETOFbw+lA2Xkh8WnGEatVHqj/jxQ
         uH2OAb7qoHYmNx67/+lfC63LoBhe1lGcmjShxec6at6hCXtRBLZB/L52bQvulj37EN0w
         9qPuwgkb4HpHh3uQ4qq+Q0mYQw8ePbRFz/TEqKlAIPoVN2I780aXiOYK0p60f42MCYrw
         u2pXRfUpbuErv2XC8m0WLl6+97PdPyNhvfZ1stS4GnRIAFz0kiUw8bbaYlIXDyoxUiHF
         Z1yg==
X-Gm-Message-State: AOAM533xuGtvHNe4vqxvynwuiHc6LbNQbEZr7MDETwLdVzaULG2/opud
        lMg8Vf6eBXlSBKClY+q5JTk0shysocGdegYjEpw=
X-Google-Smtp-Source: ABdhPJwMU1VfSJi8s0XWdmyOEYfbHYaIAc8JNzLqBgNQyXmUxDRjoXT8gYrPH+3UHX9AgbcRIEYZuuGKbB/d4lkyUqE=
X-Received: by 2002:a05:6870:a70a:b0:d9:aea4:a62 with SMTP id
 g10-20020a056870a70a00b000d9aea40a62mr1350611oam.143.1649935859507; Thu, 14
 Apr 2022 04:30:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: gavonkomi32@gmail.com
Received: by 2002:ac9:5c47:0:0:0:0:0 with HTTP; Thu, 14 Apr 2022 04:30:59
 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Thu, 14 Apr 2022 11:30:59 +0000
X-Google-Sender-Auth: y209aRF2J1eEo37miR8awKkCsGk
Message-ID: <CA+rrxF2f0fNEG4FXMBiZKpiZq8kPEtfK+x7Z_89xbRNgoaze3w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0JfQtNGA0LDQstC10LnRgtC1LCDQv9C+0LvRg9GH0LDQstCw0YLQtSDQu9C4INC00LLQtdGC0LUg
0LzQuCDRgdGK0L7QsdGJ0LXQvdC40Y8/INC80L7Qu9GPINC/0YDQvtCy0LXRgNC10YLQtSDQuCDQ
vNC4INC+0YLQs9C+0LLQvtGA0LXRgtC1DQo=
