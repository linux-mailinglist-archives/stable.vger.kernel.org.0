Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F19D1F105A
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 01:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgFGXNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 19:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbgFGXNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 19:13:19 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B33FC061A0E
        for <stable@vger.kernel.org>; Sun,  7 Jun 2020 16:13:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z9so18151717ljh.13
        for <stable@vger.kernel.org>; Sun, 07 Jun 2020 16:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=g+VCAHAoWL4xJzVklduY/eoWtSGEo/mtgOVbK4Gi8+Nb3iUA9nZ3+HpURn1aAS4I2F
         HgncHRAVgNkCScp4JmCRZ6XFU3G8c02cMhEcPp8EuUs0z4IdxNy5RFTIg0wGresilJys
         7Xs/4oaf1EdtDeE5ucm3WjBQJQHs2UeKe8w+A0LolHIqhPQJFp3cRWeDIG5ojFI9U7/s
         CKPy7p3+P/XCcKSStb9PXWuZRqw2Svek1LcKl2GqwaUR0LIY/ijp8/kUOGqMKg4XgNq8
         B6+/e46ixcPOZfjXHofCu+B9C1dkgWMhimQy/2YJw/pzPLqgGL6KJ7eDVPAoGTDOH5Hg
         Hckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=eOuxvAlY3jdfMhoPetW0pmwRvTRLlDFxM7aR8xbokcevNatiqSnVJ6qFApx1IGEW0c
         apnBBVtYygp9lC1QryKZJkhJEBQvjoIGMwHIm547WcmblzcHuUgBgdsEZrv6v8YYKdJH
         wk4V8yblkNvok16EWaPLr1LQD9C9oCHmjkTatpujLxyCyF0JQ7RwOk+f9VoSX2Vsxtpy
         HaShnZhz3CfaBtaKVIBCdP1037aNykJtMnR7Klty6Act60PzznVVkuDUx/RA3ymCdDW4
         oLcixksJgpfS74OclH6qiOtHP9dlbt0tz9AicKLP7jOtwtJP+aXSssq9mvIjjbbMB2bQ
         P3EA==
X-Gm-Message-State: AOAM5328bg2nqZxNxoSz0pGKpkLGKt0QANH05btDhdnjgAL2vP+lak9H
        BUsaHAD8Rt+lpydd5JI+2X/Aym363cdkjRe8QZA=
X-Google-Smtp-Source: ABdhPJzme8PSx37VldFgrX2JPtlGM5JDMXscegPHbrAYCIXVYZupzKIgpKJ0syu70AFEmpjJ4bacfIi5FIWo3jRFXBs=
X-Received: by 2002:a2e:584e:: with SMTP id x14mr9045064ljd.380.1591571597674;
 Sun, 07 Jun 2020 16:13:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:313b:0:0:0:0 with HTTP; Sun, 7 Jun 2020 16:13:17
 -0700 (PDT)
Reply-To: sylviajones046@gmail.com
From:   Sylvia Robinson <lorijrobinson589@gmail.com>
Date:   Mon, 8 Jun 2020 00:13:17 +0100
Message-ID: <CAKXTXJw_ePTi_bgdz2qOC8B=A0q7nHjipsB0vbXcov95PFSeag@mail.gmail.com>
Subject: =?UTF-8?B?U2l6ZSBnw7ZuZGVyZGnEn2ltIG1lc2FqxLFtxLEgZ8O2cmTDvG4gbcO8Pw==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


