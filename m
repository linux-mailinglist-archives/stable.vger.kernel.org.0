Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD452F7041
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 02:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbhAOB4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 20:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbhAOB4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 20:56:31 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51472C061575
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 17:55:51 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id hs11so8778021ejc.1
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 17:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mp7GmQkSgsWnF6M0R2j67vWc0/pzpZBP/CeL9Sbwrlk=;
        b=aXH+KHxYVSOqr4NCqkdF0ilN9fdpF7IX1vFW87OWEqc8aFURcm67XpcW9y7hGpF+5b
         VCOGSD3w5X3HtyGRqw0i/W2iJRgpVucCgdTgVNKoIyDodZD3O37/fKE2khsBhIzOa1LL
         UfH/2teNaY6rrvEkdL/bmz4Tpg64vpzJQMhJ1D293GblugzvZ5Jeqnqs/jfW9MROBSeu
         yDeZlWlVOpjFuF58GI/NHLOQ6sMOOwV4Z3N1SDAsZMO8EFZnFkWj6jQpyhaTyxpsijXt
         tY2YsAqh49DiLEaWjzd/M4FnR+g/cboCYCnmPvXgUagotZ1ptlnYDihpfPJhieHbt2FZ
         mzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mp7GmQkSgsWnF6M0R2j67vWc0/pzpZBP/CeL9Sbwrlk=;
        b=J2yyluGuL7dp/EjsceUAFn33tgynGMjvxBoXF07ofSf2ntjbo9SL4qi1wOJdUi4cln
         PaTFXicznbbMAKaUFbof3FRBAoXa9NM29iBZGfKN6X3LedqKiTgjef3N4gfb0KtDkwiS
         L71F/TTDbMl+grj3yfjmQjOOT/aLD4R8Je7I73GVF36WCkr5aNilUBHOl6zL5AhDs25p
         GY81wosRHVGrCWVGHy5PnW53L8db7dtDTQY0H3JrauRdjd94ux0Y78qy/8J2XXwjpdCA
         GLQ/N7K034ucD8zuJ6JaefPMnwbSl8RDk9cMUU4r3LAcEDVHWKnb9cp0pe2FI8XvU9Y5
         kTzg==
X-Gm-Message-State: AOAM533d/gYbJSe34UqMQ46nJYoldd5J5uoSXSF1drGPBTuPXUbPYC0I
        r8e0MTCLoG/jXXnTzKJOoroAFMSoFdZTOkU848teOg==
X-Google-Smtp-Source: ABdhPJwq1YZ5agPUYN2J7m7HMwUugfICz6/tg3BW+u1U6DL1ZsMWcReQBK7LOdBLEeH8ZFP51doKLWQesvnweR1L6J4=
X-Received: by 2002:a17:906:f905:: with SMTP id lc5mr7222505ejb.177.1610675749568;
 Thu, 14 Jan 2021 17:55:49 -0800 (PST)
MIME-Version: 1.0
From:   Saied Kazemi <saied@google.com>
Date:   Thu, 14 Jan 2021 17:55:13 -0800
Message-ID: <CA+Um-ghfTG=+x8iT-uPikM7NNsN1J6CCiztxsBgQ9OJPUBQjyg@mail.gmail.com>
Subject: Fix CVE-2020-29372 in 4.19 and 5.4
To:     gregkh@linuxfoundation.org
Cc:     axboe@kernel.dk, stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

To fix CVE-2020-29372 in COS kernel versions 4.19 and 5.4, we
cherry-picked the commit "mm: check that mm is still valid in
madvise()" (bc0c4d1e176e) that Jens introduced in kernel version 5.7.0
into our kernel sources.  The commit is small and the cherry-pick was
successful for both COS kernels versions.

Because COS 4.19 and 5.4 kernels track 4.19.y and 5.4.y respectively,
can you please cherry-pick the commit to those stable branches?

Thanks,

--Saied

COS kernel source: https://cos.googlesource.com/third_party/kernel
