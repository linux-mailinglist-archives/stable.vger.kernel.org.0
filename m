Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4E118FC8
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfLJS23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 13:28:29 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37010 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfLJS23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 13:28:29 -0500
Received: by mail-lj1-f195.google.com with SMTP id u17so21029789lja.4
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 10:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=RIodWe1nkh/ZmjA4NYRJupKGdYSuYzR/jeXTTBUCLO8=;
        b=I9DuZ+jZtQI3f9Yy6a4UIE6cTV597tVSperrV5tPvMT5POLJaSAO5mAYlpztWp+rj0
         0Sz5jUmdlOXuV2+1PTwG+TThnUtd9wcNYyeAA3VY6siUftXvQyfTAtN7UBepGmynicHN
         XSxlYFw8Bv//MnaEfT2V5QKTllnYYXUvevt6zGguDM7Iq3khk7Jt50RURiwAxCMTnaZs
         VmWXuGdkCJ7xmBtE/oYqwUCoVHv6MY8av/Oo7FAt2YTmSc0rdG8xbPIAMR4A+21MzhK+
         yXjFeEZYz9PfaFQ11Y6gXgnTsbUKi5e8JL3tAdJEXDJoEQnJlxR43w4WcxksBdoXNew0
         1Pew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=RIodWe1nkh/ZmjA4NYRJupKGdYSuYzR/jeXTTBUCLO8=;
        b=Uv0wt+cUy1IDYW7NJO3fpPBhumY1NpDwIMvJV9bAgNJJW9e4DcJgA+ppQJu+LY5Nuj
         mFQWAbBrGLhaQaVKiAyy2WDFjsQAIr3u/kHB44cRHyK8cDdhcSSinFGH5Zx1eyIc2Ne7
         mvY4tW6nJOmN/4YgnAXC0yqdJkfIIEo0SFJIdXZM1uebScZrj0t8ywyOM6eNGKBgOWi+
         iwbOBmRqOE+nSJz+9X6XJlw8mS13Q1GIaGiA45gvPLDYNINyZnumYYU8Pm5eZBnY+sUS
         YNdn/j5ODxLGOfU2gmWjcAJzQNueu6xvihfBhJI9sJUdAygH7FcKeLK8s1geNxo950vK
         kTuw==
X-Gm-Message-State: APjAAAViAmr83wonECtnH6PFN4FVMR6NTPKiQCzJ/Fck4umszI8FJQJo
        lmgf1WPYLE+1IwWzZ01mv+N5+YNVM1Mm7h88+Zk=
X-Google-Smtp-Source: APXvYqzbbhHJpj0IZbr2KUynIe0dY171CcgoqsG6aOnbvasR0NmPCMxIXQ4Mzi3brD9c7QQsEwio4G037O1kJcxvzjg=
X-Received: by 2002:a2e:8152:: with SMTP id t18mr14883228ljg.255.1576002507116;
 Tue, 10 Dec 2019 10:28:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:994a:0:0:0:0:0 with HTTP; Tue, 10 Dec 2019 10:28:26
 -0800 (PST)
Reply-To: barregoigwemc@gmail.com
In-Reply-To: <CAF49TZiLeo-Q+aTt7vr0TS0S+BSEn9Q0XgdqbmUgP855kO--EQ@mail.gmail.com>
References: <414221510.3122818.1548779864743.ref@mail.yahoo.com>
 <414221510.3122818.1548779864743@mail.yahoo.com> <975659070.108434.1548850084353@mail.yahoo.com>
 <CAF49TZirJLG5eKmxM3TvKHkp7cTMxcGrX+HP27Kzqd_e3jg5pA@mail.gmail.com> <CAF49TZiLeo-Q+aTt7vr0TS0S+BSEn9Q0XgdqbmUgP855kO--EQ@mail.gmail.com>
From:   "Barr.Egoigwem Chudim" <barrtchalamlateh2016@gmail.com>
Date:   Tue, 10 Dec 2019 18:28:26 +0000
Message-ID: <CAF49TZiir+WKQzhKh2Qa+_VwGR1MVWj1juTo51vxWKtgWd4Lkg@mail.gmail.com>
Subject: Fwd: Please do you receive my previous message?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Compliments of the day my dear friend, I have a confidential business
proposal for you, I am Mr. Egoigwem Chudim, an attorney by profession
in Lome-Togo West Africa, I know you will be surprise to receive this
important information that requires your urgent attention. I need your
interest in helping me claim the sum of (US$7.900, 000 Million and
150kg of gold bar) that belong to my late client, a nationality of
your country. He deposited this money in a bank here in Lome-Togo,
before his untimely Death with his entire family, WITHOUT A WRITTEN
WILL LEFT BEHIND, if you are interested in transaction kindly use your
direct email address to reach me by my private email contact for more
Details. ( barregoigwemc@gmail.com ) As soon as I received your email
of interest I will send more details of this transaction to you.
Regards, Egoigwem Chudim.
