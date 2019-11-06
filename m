Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F25EF1FA3
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 21:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbfKFUTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 15:19:18 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53943 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfKFUTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 15:19:17 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M4rHF-1iSj1H09ah-001vXS; Wed, 06 Nov 2019 21:19:16 +0100
Received: by mail-qk1-f178.google.com with SMTP id 205so24518838qkk.1;
        Wed, 06 Nov 2019 12:19:15 -0800 (PST)
X-Gm-Message-State: APjAAAUnMYsojh2aMFR+f6NI/jYW+cfqoygl/ne7hkfyNHoQ0qRxdEjN
        0H59YANCknd/+5d5TN1RKDpFNeqVK8kNg8vcPDg=
X-Google-Smtp-Source: APXvYqwMBzeoLnci1/w4kfeKogyBl0BHz0uvHYM2FQCfg8jFF6mF6fPo8f/AFfZmTyQ2tqpFwySZLrwcZlHSo4TLo9o=
X-Received: by 2002:a37:9d8c:: with SMTP id g134mr3951247qke.352.1573071554758;
 Wed, 06 Nov 2019 12:19:14 -0800 (PST)
MIME-Version: 1.0
References: <20191106194715.2238044-1-arnd@arndb.de> <20191106194715.2238044-4-arnd@arndb.de>
In-Reply-To: <20191106194715.2238044-4-arnd@arndb.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 6 Nov 2019 21:18:58 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1t9kWcSVDyb-a3CWXgukLGVV9orRj58LbsGgCM3Z01JQ@mail.gmail.com>
Message-ID: <CAK8P3a1t9kWcSVDyb-a3CWXgukLGVV9orRj58LbsGgCM3Z01JQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] media: v4l2-core: ignore native command codes
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Daniel Mentz <danielmentz@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:lDtT+hHflBMaITdOSRRJyP7jzOJ9e7HrjEIPo0EaotFjUOCKkCp
 QNSy3fAFp3pjksNTsik8PNChy+CRxmcBZOihep9+hcLHXGswTEVd4UgotWOW0RIjJa+uXEh
 sR5ZnwJHS0P3vKudOPhPyNLuj7ukXA+2BSYwP/OxsJ/EVi5lUhwIgCWg2FQvptBqKyMuYxl
 oWacEErta7yKqNkFGpqqw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JwY9fJHl80o=:GSKdnhSyvIrY2ndpNVoRWP
 bt1yU6O5vMDg28CR5+6DbcFHuB+Fmfv5xvQf3IEnFbSFhJfaLSeZ19AY5Hx2xBrIzYPKBtl9H
 qBDNECfV+WfkiYTYQ8LXZ5Ab7nJwtYlBNNVXT8GCDMGbIWRW5nVr+0pzSjvmBFYds5fFZWqJH
 sM9GVAvFg9rgNc3ipA+zCFC563/Y0qtejY+jDuHY1sp2AbLNIKZMoHdAEu7bVcgFGNzu16fpj
 oQKF/UGT93tuCRCk5zQHud0f1pxBmvqr6s3+zBj9UIMSDNy93ees7mkg0fF8DZE/kWS+5uw/z
 52OawcCVlt8IcJoIXNXcK/ZBaUJLojXchlhGqqrOLuOSGSa7l8NJuStpoUv7kBgikVTAzdVrt
 /gJABE16dVyUSIidR35hsOSMtrnFgfOgMl3JzQjBEA9OwRlc66c3RwDf7OBVOEaApwfYWrnKT
 dFOvKYSE8WJQgvQKOlv5WjufKGBLUzwFqm6sNd1mfL9xc49U6huun97ETkvtum/Gl6o5vQ1PB
 kCKA/YJXnFrEWw0n/NVkCBq6aC1VJEhJN689LtOv4jbMMBC4oguAHDuBXsgNRoEwTt9/jHcEN
 eQ8UaiNMk5r3aeMRs2oD6bl4i95yyJqmOaMqwbcIeUhewuLrMH+HrU78ZghF9t+MW41yIhWaP
 hbgK5TXcvpo6bOBAUnNREbX+ntrNMXBT+YORdldP2AYjHY2L9ZjAK4HWlCTyIKmFJ54T098Z9
 YsBVTAvY/pqDfGNnWKVHUttVeqovTTrg7p/cE4yPF43PmpndTqUfHYRbJpri8rLgrujiKdXoo
 HMYhGHuDE9sCBiCaXTo1ZSNgWcHA1A4Uz1WsmII9QUZxa4G7x5mDyvlBV7yCWo0KYUOs7SAM8
 Le/IMvvUUy9pdmh1EeHQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 6, 2019 at 8:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> The do_video_ioctl() compat handler converts the compat command
> codes into the native ones before processing further, but this
> causes problems for 32-bit user applications that pass a command
> code that matches a 64-bit native number, which will then be
> handled the same way.

I noticed that a change to the subject line made this one less
obvious, I've changed it to "media: v4l2-core: compat: ignore native
command codes" in my tree now.

       Arnd
