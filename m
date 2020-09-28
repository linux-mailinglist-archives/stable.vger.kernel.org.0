Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE3C27AA03
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgI1IzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 04:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgI1IzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 04:55:16 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED930C0613CE
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 01:55:15 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id z23so7343704ejr.13
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 01:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=YYW1UjUSN5ERtop8k+njuwIBj/bcwzHHKMVex67buSM=;
        b=ehDn/HL7jSgRAZuMKNQV+hWKbSck1FjW8Qw2LGTJ4fFmj/vxYgQGGJByqKU0IpYDtC
         Qr0hNN6NTnuZRbXPr2tcAcqzrERDb3NlB/XjPMMRFyW3KqMJs0nFpaBSwUo1zmSHoi8T
         QTN6PKScclcyuE5qARMU9g7tbNee47PALJU+0/veYVXJ5hFDezBQKIaGciMBuhzZPq2x
         tviFTaxsW5/c7+hVQpUdPPoxroNq64iPmiA30PJQ8CK4exbRoV50vQTWJ5L9IyNycTkD
         CVbUEj61HlWcZRux544NiiM2y4bN2pUlgG+4xjakfy86SdfX53fOmAsd8D+c0FKBS1HH
         32fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=YYW1UjUSN5ERtop8k+njuwIBj/bcwzHHKMVex67buSM=;
        b=fV04Mbp2rtiNlclG8I7tLh1N9VT80Qu5V0Horr+iDS1biVMAswVerrQMuOqBAxcpsO
         Zr5KX6jf+XoRhuL3ctnlYCLAM0wqEvfxMpBAqUjbLQuMU49kNuV8Co2EtrpPnsX02k85
         uI/+zKgisf94WMPQmy3+jvlo83l5lKApX+jdsF8vqHdD8dPJLNzLqj5xhb6FjIjz9AUS
         9cpr7ygpA+2bvDNeIZ9dXeigf8tjCZhLoG2qoTEyzrl8GjZStiefpwPBPwO0x6QzSSiY
         A9H2lVkuIcVHlVWN02IAEB/27SWvVme5WfOVU+tab4588RqoVYqwU2xTUC5aroxTq0nu
         qDbg==
X-Gm-Message-State: AOAM5318DXs+AXt3WsJ5R7CwQ1XbMD1BYC8S435+RCgbaRfhjlk5yvqp
        Grzb3IiI9tHRrE9WQxB+yi0Xbi5E0dN4KCiHxvnIMJBcYLFGz7Q3
X-Google-Smtp-Source: ABdhPJxdlgY1Hs0hDoeEXGhyaopLyT/r6zKxew8mP5kkptoqTZ0GoORdQDMPSMVtsz10Bz+KEAhcn+TN0w6vUJ98un0=
X-Received: by 2002:a17:906:dbf5:: with SMTP id yd21mr590485ejb.521.1601283314368;
 Mon, 28 Sep 2020 01:55:14 -0700 (PDT)
MIME-Version: 1.0
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 28 Sep 2020 10:55:03 +0200
Message-ID: <CAMGffEnTKBjKq7xLxFBPcigwrA4=LM+M_EL+tGYS_oZeY=2ywA@mail.gmail.com>
Subject: [stable queue/5.4] build errors on queue/5.4
To:     sashal@kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

I noticed build error on latest stable-rc/queue/5.4 branch:

util/parse-events.c: In function 'parse_events_add_pmu':
util/parse-events.c:1373:11: error: 'struct perf_evsel_config_term'
has no member named 'free_str'
    if (pos->free_str)
           ^~
In file included from util/parse-events.c:4:
util/parse-events.c:1374:20: error: 'union <anonymous>' has no member
named 'str'
     zfree(&pos->val.str);
                    ^
/<<PKGBUILDDIR>>/tools/include/linux/zalloc.h:10:38: note: in
definition of macro 'zfree'
 #define zfree(ptr) __zfree((void **)(ptr))

revert both
d6ac1bd91161 ("perf parse-events: Fix incorrect conversion of 'if ()
free()' to 'zfree()'")
b6f48cb0c18b ("perf parse-events: Fix memory leaks found on parse_events")

Fixed the problem.

Thanks!
--=20
Jinpu Wang
Linux Kernel Developer

Application Support (IONOS Cloud)

1&1 IONOS SE | Greifswalder Str. 207 | 10405 Berlin | Germany
Phone:
E-mail: jinpu.wang@cloud.ionos.com | Web: www.ionos.de

Hauptsitz Montabaur, Amtsgericht Montabaur, HRB 24498

Vorstand: Dr. Christian B=C3=B6ing, H=C3=BCseyin Dogan, Dr. Martin Endre=C3=
=9F,
Hans-Henning Kettler, Arthur Mai, Matthias Steinberg, Achim Wei=C3=9F
Aufsichtsratsvorsitzender: Markus Kadelke


Member of United Internet

Diese E-Mail kann vertrauliche und/oder gesetzlich gesch=C3=BCtzte
Informationen enthalten. Wenn Sie nicht der bestimmungsgem=C3=A4=C3=9Fe Adr=
essat
sind oder diese E-Mail irrt=C3=BCmlich erhalten haben, unterrichten Sie
bitte den Absender und vernichten Sie diese E-Mail. Anderen als dem
bestimmungsgem=C3=A4=C3=9Fen Adressaten ist untersagt, diese E-Mail zu
speichern, weiterzuleiten oder ihren Inhalt auf welche Weise auch
immer zu verwenden.

This e-mail may contain confidential and/or privileged information. If
you are not the intended recipient of this e-mail, you are hereby
notified that saving, distribution or use of the content of this
e-mail in any way is prohibited. If you have received this e-mail in
error, please notify the sender and delete the e-mail.
