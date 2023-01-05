Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF6265E5D1
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjAEHNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjAEHNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:13:32 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF085276E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 23:13:28 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso1170977pjo.3
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 23:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RUY5y6zLuR5cWqeaKguClMSYR6J/UjlVX1mPxUIDiqs=;
        b=m6nwvMfodTUiK5T/Uv1DDCxwV7esGTDPYetNfGjlb74iiqzdi73OInACFRwUrY56V9
         /EYwAjG9HUXzOtpQxYxIO+vZxJcg+9/3sPkBJ64QgMY9FNKAvPd5AuX/lZniF77b6SY8
         hT67OEXq2h20tdiPRPEzspvjufeNJ/DegP0w1qJ2qR94lotVsWUtOGu3Jiye+SBzEPJb
         S74TmtP8ZmgsGdPNpkY6sN3Ka0DZgT8wdFOA3kTsjW7umjEpM7KXfX+vftH7iaTk8Rv3
         GSCdO4BUpOOT/WInbiQeppK2uLLHS/31PsUz8X+UR98xcZW0tEFfaelkd8ZNkyXC070H
         he5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RUY5y6zLuR5cWqeaKguClMSYR6J/UjlVX1mPxUIDiqs=;
        b=nwSALPk3WhV00loVx3FCVEsn79vXaArbu3F/fWRZbDn/Xis0kC4YvSylHFRh9i7RpZ
         4pQbKvgzCW3OOE5ibW+KtcBOunu3xeMBR5KTfrJpUY6G0hL88QGXVPj6u93MrzGIIZ4s
         CaTv8Sa9JkV0X96hezXho6GZCH/TsIK6Mek/64iVbIU0RMsbXFdUz1W9Ssp2qXt0Fi/s
         eBlCrWSSsnFWuCJrAi92WiMJBxrBCuvK/XFT5xlOvbpz9Jl771HqNBEpogO73EqW2kpu
         /Jr+5/CPNPR4ZyOY3TLcbPWxZwhJ+fozZ74lxoj4+2R6g73KX1YM12JdSSyv2KYx9l0S
         OXRA==
X-Gm-Message-State: AFqh2krYemkKIPgqDIGVO2YuQ/Wot52+OYJKlHpTPDfmrpYSYVxGpcjK
        h1h9TZ63y4IEMDuJq5XNlRTuyX7QEWItX+pk1AI=
X-Google-Smtp-Source: AMrXdXve2/QPtggyHVkQYX/DWrl5c3Gspk9EZSNuM17Jo3w86E17C5mQJ1mhUzKuzi7HvhmoutIC6PSz/J3JRLiXwGM=
X-Received: by 2002:a17:903:130e:b0:192:58f4:59cf with SMTP id
 iy14-20020a170903130e00b0019258f459cfmr2465140plb.170.1672902807947; Wed, 04
 Jan 2023 23:13:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:570d:b0:96:36ff:77ff with HTTP; Wed, 4 Jan 2023
 23:13:27 -0800 (PST)
Reply-To: garryfoundation2022@gmail.com
From:   Garry Myles <sadabridget13@gmail.com>
Date:   Thu, 5 Jan 2023 10:13:27 +0300
Message-ID: <CAH=MdMj766Khw8Dk2d=4=+b5WsSbuL2N_0-2ibomMQ7eTxBY7Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=20
Guten Tag
Sie haben eine Spende von 2.000.000,00 =E2=82=AC von der GARRY CHARITY FOUN=
DATION.
Bitte kontaktieren Sie uns =C3=BCber: garryfoundation2022@gmail.com f=C3=BC=
r
weitere Informationen dar=C3=BCber, wie Sie diese Spende in Anspruch nehmen
k=C3=B6nnen.

mit freundlichen Gr=C3=BC=C3=9Fen
Garry Myles
