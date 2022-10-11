Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF4A5FACDC
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 08:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJKGdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 02:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJKGdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 02:33:43 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAF989825
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 23:33:42 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id f37so19613404lfv.8
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 23:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NMeG/drUDOGSJaAno/7/4Ex/r8rJRwuoIjafQIkcMeU=;
        b=T2V2Fsd+hcsJdqu5qic8+TVewSFmuWkx0A/lQEAxvWaKD2u/thVV2N4Chh71FOG/ec
         w47cqu/85o4EBB82ZnpWZudKvLjP1n1VDO5wof8beo4ixk9iruli0P8WuiEvbXuJyJDl
         CcJjhDB7MvWXauhLMXxv8Dp8d60rawa559aBg2KztQNcV32Fbymv517Ne+PyKFI8072R
         Cai+f9wDUj/wBUX9rubJrSQrbOsHB7CSsd2xCW0QfzJ/BMBbt6N5wkLN5rE8O6tuM81m
         TKx5UBbkCWzf2nybiGzzbajG+Tt/W/onUCHOFqC5bzhtGcrz3ajYSoaPQQfn/tHyf2SU
         LcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMeG/drUDOGSJaAno/7/4Ex/r8rJRwuoIjafQIkcMeU=;
        b=C0kTZPKIPLdMpWzZCbldM6IysYiqrvVYS2Tgh438+q07dxK6qXx6otNvTQsDyfuhqn
         k39zOHdLEIA0WnZ6WvH3Px0gKZlWTZxzPq3oIC2u6rIZ9/eb1UqtjkBGr31rn0AZYcSZ
         Szp0CoL6QJm/QkCuTdS8gLoZ1M5Ofs4Fs57fvwAzOVSeknyczJON9kyyM1NC7LWVTc2u
         vKWMfWk5Lc9snihe9fpwtNl9+87XIRyd9RO8XQnS5/hYvWnsPOr81RxCl9SWF4jd5/Tj
         d2tyY0LvVzPoWthklTImfKbMkTHU4JPuN/RohjmhEl2aId1n7/+t61SuMwpWwYpipQMr
         MJkQ==
X-Gm-Message-State: ACrzQf3frhPSt68VADcaCLVQ5T/qfPdKZticlDjlGNwEL77qgmn/xf3A
        NXKhW0UFoc1UZK/6fkYSvz2/V+Gg0tHRw58GNGc=
X-Google-Smtp-Source: AMsMyM4ZDUW6ERgmEqBp3vc9qEQ5JbXA3r+pGnLosmMRhRJGXI225pI9V5K55t5+JvAOvqwlwOh4KG23+HXfrxgOErU=
X-Received: by 2002:a05:6512:458:b0:4a2:c67c:afbd with SMTP id
 y24-20020a056512045800b004a2c67cafbdmr5574655lfk.76.1665470021070; Mon, 10
 Oct 2022 23:33:41 -0700 (PDT)
MIME-Version: 1.0
Sender: nomessiedih@gmail.com
Received: by 2002:a2e:b5b8:0:0:0:0:0 with HTTP; Mon, 10 Oct 2022 23:33:40
 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Tue, 11 Oct 2022 06:33:40 +0000
X-Google-Sender-Auth: _DmlAaXNDyFUEdAIAVAYZWw22h4
Message-ID: <CAETu2Su6tM9zd2pYiV7mGSY=C8Avj27WWjYKTBuYBfbB-UnLmg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ahoj ako sa m=C3=A1=C5=A1? Ver=C3=ADm, =C5=BEe si v poriadku. skontrolujte =
a odpovedzte na
predch=C3=A1dzaj=C3=BAce e-maily, ktor=C3=A9 som v=C3=A1m poslal.
