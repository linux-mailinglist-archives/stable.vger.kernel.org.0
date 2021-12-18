Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2164479E17
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 00:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhLRXLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 18:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbhLRXLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 18:11:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609FAC061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 15:11:51 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id f11so5360182pfc.9
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 15:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=NKfzAz02to+HLBJJBx80vvf3VbWcNBYKs5kBDpooUK4=;
        b=Ah3bqpaq+kTklj9fEr/PJ8AzhxOo4aaajBvwBudtoUJudrcoFtIWitdOehSQm9r3H/
         MWYDZyfqW0MJzZhNZNEG/tDrTR3pCQibJaayfBOOdktZMg/kfGkS+5qLtzDzqNFaU170
         3iDGiuxiGLlSB1S3Ew85mVgI/Zxm6CwjcNDcgOudRlU52akV+YEYe9UtOmQ+2xN5/+xe
         YwyLqnQo7GMu2e6H98bQoQ3JF4WcAcHrm9DoGuC9Z0vWCgbKfvCyopAGJ8UuX1/rl0PD
         5LSGXmLL8QOOcZsPbH06x6Hzzw1JWywq2G+yPOoo6vWjCrFnITrR+N5DJk8xNYv0ngbr
         Eteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=NKfzAz02to+HLBJJBx80vvf3VbWcNBYKs5kBDpooUK4=;
        b=MnBkLf2PkQGuvgMGEQ7DGzlWZLipb9T8He1ziQ1EpDzUmDOfRnZSjo6Fsksv7LdXc0
         gK54N12MP78Z4/qjGSoCHbtyQ1UvWKyo30aHIqx/LxJHs4vOgFsq708+IxX698zMgau9
         7a+XEQ3aKyiOzfVqQDuOmTvBReAV+sb/acUFuqxVzsc2UlbrIGaqhNXznxvPRWw1ECbV
         QRDxapsghcU10HOepCGBc7MJ2iFUpv8uLEFT7uwhauSYlggmJoyNgDgmUQsSqyd6xhT9
         6VWGg3jcOlzqHx7aqzbKqzDhHIdIx+ZDfgJ1vrFPnpTwYWMJx1w5LP0RifENm12cYKgb
         oLSQ==
X-Gm-Message-State: AOAM530XLAQWWm7VxOoQOXMAcDEs6vyaLEUFW1hBxzPgrysZPoCZ0uLn
        CjdmnrSRSkkgxyrgwEZlhAeYDJxh2+9aaEnQnIpNob9QA3Tlb4lq
X-Google-Smtp-Source: ABdhPJyFwg0NbVPjDFdoqehXvhUV/rkLM0HmOV80D1Xff/mXLhKYK7ZjEH04ZxUUFCRhds1lwexCZKpY2j3r3HCk1Jg=
X-Received: by 2002:a63:414:: with SMTP id 20mr8593663pge.178.1639869110470;
 Sat, 18 Dec 2021 15:11:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a11:10b:0:0:0:0 with HTTP; Sat, 18 Dec 2021 15:11:49
 -0800 (PST)
Reply-To: claimdepartmentfb1@brazilmail.com
In-Reply-To: <CA+OARtvubeQd9ndP7diMm_+TSzYn7oDHKvJLokX0YnJuF0UCeQ@mail.gmail.com>
References: <CA+OARtsc9_yY0kNuKBwr78j-2U0LMu7v5w4G7mbQOe4=kSHXNg@mail.gmail.com>
 <CA+OARtvmwUm6MOUXcw3n_HYL376eajA3ayT=zNWLetYYcyraKg@mail.gmail.com> <CA+OARtvubeQd9ndP7diMm_+TSzYn7oDHKvJLokX0YnJuF0UCeQ@mail.gmail.com>
From:   =?UTF-8?B?b2RkxJtsZW7DrSBwcm8gb2TFoWtvZG7Em27DrSBjb3ZpZCAxOQ==?= 
        <riverminerscompany@gmail.com>
Date:   Sat, 18 Dec 2021 15:11:49 -0800
Message-ID: <CA+OARtvgoaAPNGYNE+Fdh0LdV4TcFcjaX3FjCYpCVQmJ0Ke=1w@mail.gmail.com>
Subject: =?UTF-8?B?SnN0ZSBvZMWha29kbsSbbmk=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

V=C3=A1=C5=BEen=C3=BD p=C5=99=C3=ADjemce,

Fond pro od=C5=A1kodn=C4=9Bn=C3=AD ob=C4=9Bt=C3=AD COVID-19 a zbrusu nov=C3=
=A9 auto.
M=C5=AF=C5=BEete si prohl=C3=A9dnout na=C5=A1e webov=C3=A9 str=C3=A1nky a p=
rohl=C3=A9dnout si sv=C5=AFj nov=C3=BD
v=C5=AFz p=C5=99ipraven=C3=BD k odesl=C3=A1n=C3=AD k v=C3=A1m.

http://www.toyota.com/prius

Odpov=C4=9Bzte rychle.

S pozdravem
Lisa Jacksonov=C3=A1



...........................................................................=
.................................................................

Dear Beneficiary,

COVID=E2=80=9319 Victims Compensation Fund and a brand new car.
You can view our website to view your new car ready for shipment to you.

http://www.toyota.com/prius

Reply back quickly.

Regards,
Lisa Jackson
