Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE3E12E529
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 11:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgABK63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 05:58:29 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55777 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgABK63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 05:58:29 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f8cfe1fd;
        Thu, 2 Jan 2020 09:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=1gVIOhY+u8AhCXDCI9oGBXaH8oE=; b=w9VpIE
        Wg6c2Zj4fgbXNbMd5W9DPHSR6J7CewQ4twfNHv6AiOhYA7V++oCQuvYVsrEB+w/U
        qHeO/fq1mhl6VU9uO8lVZj40icJ9688HNAfgM31g8AbKv51Z4iA+miVBhY6NpojF
        o19/LDa/Nx7pIvnH3zlnWQGX7brA0Cw+SE8Z/+9e8C11zBDjeNQ4eSgJ6sC1XFZ2
        6PQVlGqUIc3aa2JqbIAguaZ1TSys1Y2pcSeI4eeauI+vV4dO/LpjsNzF34Ud5HLZ
        tPtykMmAE6J8Zh7ehN3oL5dadAy3kTALewvEnc4nLNeLc2llTxpZX/4xA0WHmIPY
        agNyxZJESxKhu+OA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b1032272 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jan 2020 09:59:57 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id 66so56535028otd.9;
        Thu, 02 Jan 2020 02:58:26 -0800 (PST)
X-Gm-Message-State: APjAAAVkfU1h2PH/rowPkD1RgWXiL7Dt4coCyJFLEXfqzfNBdDRCI6t7
        dj7ZthYXMzNQkyyrMYyl3qAkNWmAbqX/hHksPRk=
X-Google-Smtp-Source: APXvYqw3d16YC7Jfrp9aGazNFsvu+BpYew09tXhaWieR6L/gBkf/gxI9tCzn7SRBtOsoMTyrCfsH4hY52pXEb/FixXk=
X-Received: by 2002:a9d:4f18:: with SMTP id d24mr88169228otl.179.1577962705850;
 Thu, 02 Jan 2020 02:58:25 -0800 (PST)
MIME-Version: 1.0
References: <20200102005343.GA495913@rani.riverdale.lan> <20200102045038.102772-1-paulburton@kernel.org>
In-Reply-To: <20200102045038.102772-1-paulburton@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 2 Jan 2020 11:58:15 +0100
X-Gmail-Original-Message-ID: <CAHmME9r7pzca4ccF_GT3y09_fJQw-EPG_35V2ZM7OVamwLuH0w@mail.gmail.com>
Message-ID: <CAHmME9r7pzca4ccF_GT3y09_fJQw-EPG_35V2ZM7OVamwLuH0w@mail.gmail.com>
Subject: Re: [PATCH v2] MIPS: Avoid VDSO ABI breakage due to global register variable
To:     Paul Burton <paulburton@kernel.org>
Cc:     "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, looks good to me:

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
    or
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
