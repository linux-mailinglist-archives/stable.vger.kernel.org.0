Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AEA23C3F6
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 05:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgHEDWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 23:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgHEDWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 23:22:37 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6142BC06174A;
        Tue,  4 Aug 2020 20:22:37 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id y18so27700438ilp.10;
        Tue, 04 Aug 2020 20:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ofreConBzvyGrDQfxuilbAKXLeoMkPPIzIEwNp6pf/0=;
        b=N7514uAp0g+KDVdzYhyIE7418iO4el1WlEo8R/uc0JNMDruL+dSdfrpNmqcZrg4CJQ
         d3RU4dEfWlxkNLTWPd8jppUqva0JzeLhWHD/GDHJDOG0iajQHvqgDVmzRiFFooaXLFmJ
         Vg+EwT+jdC+lI1DEbwieWb6+BuPmHkQs2Fw798ovWzdgksL/jOFBzmNu4fDEDnL4ASlk
         6dxKyKKR6PIJV8ioY0yneqQGrs+uiMzcXCxiR/p38wUP0duUUXrp5pos4QfK58nW0x/R
         mvufzLugrgYF50KbcOLX7ojfQ9x/mYsHWTrVkHJjsKBqbaHVySgfShEadU4d0i16ltv/
         G48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ofreConBzvyGrDQfxuilbAKXLeoMkPPIzIEwNp6pf/0=;
        b=LjrOseJE8yu30Jd+cXHq9SM6jx4YUKGbXx7rdjloDLYXVj24YAkZkJF+4C6lOHE8eP
         woWTJclx/kxl2IDLyMSuHSpTte7bE2QWql5fsAtqVQkLDd+osFes77t1O+3jNgs6gKne
         qx9pOB38wAFWjMYrEb2szpKJhJ6rTl5nx9LgJJs4FSg9rq4EhHarKgwR3gOFb7HQe+hh
         qzBNTPmCbTjKz1mMxHD9spgbX8sc+FQrIL1VgC8VejcLV0/a8EUqcHqaanqnQyjvqlZq
         1lgvj+C8dukcV7ZX8fifJDbxXQs/jlY4IunrxxJtXOCVwZWAsZTA3R8sN3ycPk33MteO
         o53A==
X-Gm-Message-State: AOAM531WNmO1SAA0mT/OtLbUEPujIqOEvptcqhlIjV5shu+60+khvsG+
        xzauF9gwe9lo30A99MJlU51hwkUofKSfB0n2X4u/jPE0q3k=
X-Google-Smtp-Source: ABdhPJysmU6jSHvFqMk1vgNhDUoSyDPoDs5iGIjzS49kXbHfdamiI6xz8s4Qk/7ScUo5IqJJKO3vx2dVAPHYjMtyYtU=
X-Received: by 2002:a92:99d8:: with SMTP id t85mr1760853ilk.272.1596597755155;
 Tue, 04 Aug 2020 20:22:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 4 Aug 2020 22:22:24 -0500
Message-ID: <CAH2r5mudEo8bmFMrq-9hsbKrBVbJKV0he7OyocYsbrN2cSy61A@mail.gmail.com>
Subject: [PATCH] smb3: Incorrect size for netname negotiate context
To:     Stable <stable@vger.kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit df58fae72428b "smb3: Incorrect size for netname negotiate
context" (patch was added in 5.4) turns out to be more important than
we realized (fixing a feature added in 5.3 by commit 96d3cca1241d6
which sends the "netname context" during protocol negotiations).

commit df58fae72428b should be cc:stable for 5.3

-- 
Thanks,

Steve
