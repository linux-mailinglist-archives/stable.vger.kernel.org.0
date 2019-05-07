Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE4B166CF
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfEGPes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 11:34:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34749 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEGPes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 11:34:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id s7so9329167ljh.1;
        Tue, 07 May 2019 08:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zVPm+iA8UXfnyytWDD0bNAyKVw8r/B8z7jwx9A/Rbus=;
        b=OFC/zfgB3JVNqG9xBB4T7ZJLwevlNgQAhHLrrCGHo70ZSK1aA9+jvfeYxjsvax4RIp
         QFQWQ6MkBpKOu0oFf7EkN5Lxt1qt3OUnLqDa/E4XMHuhtCDQag13uZ+7fU+zZQaxTWRV
         3kb8VhUYCevaBOA1V+WzT2ygwHjHQKExj5iLc2oALlUOWpOriru0Iku4IW6dlNUXGFn5
         1Q8pFLTpxnCZB/JRNu2WvCSnntc4A3t83IkBmVBkRdR+0bfPjGhTLgKU7K1DmZ2e1uQ/
         Z98tnaxiU5wJ7E2zvyraa1dOZ1P0qVQ4iXNKNgeq5yZQAEXzAkjiJLHKRWD0hZOa6eZL
         DDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zVPm+iA8UXfnyytWDD0bNAyKVw8r/B8z7jwx9A/Rbus=;
        b=jb8+u1gar+/D1zqVRgGh26BmP2CSsgIIuX/0p+LjOmoI3rRhkakvwc3iT0hVoLRiEE
         h48ckBPih1Fpjg0ZLvzr7pSY9nYaS9k+zA8TAH70mXYtCZeTUIcNqzLfXLjABRunLSdW
         4ESxGJxeqlV6cy9PG3AVrQwZNpLhlxBAYmDa9zqfvjnIvw8Lajv7NsyUxjU7z9u9Lj8I
         Rdl7c1U0z0unNhGa4EwQIepFkN1tw+4isSrH2+hTsiRelSpD2vZ1pokBgWc0gDWO8Kd1
         jhvVemNxLwU4/WJ6Zk6x33j+pZtHcUxcM75YMInnPthdSm58cucyV5TMj8jWHBLW+hjy
         0jIA==
X-Gm-Message-State: APjAAAWYjouqKBKTI2KflrypUQ+kG9ikkavd3JL+E6/wJ/wGjbs5LrHQ
        +WMxcNTVVlxX/WhoaU9QsMOXH9zvRiqf785lnyc=
X-Google-Smtp-Source: APXvYqxjikTtYXoUUvyDuWS3S+iQSmIeLX+KO7rhcOaHnuFa7qaK3eqAbOCl2ZZq/GAnYu4xaDb1G8ncZRoHtYmR3B4=
X-Received: by 2002:a2e:9188:: with SMTP id f8mr15331839ljg.100.1557243285680;
 Tue, 07 May 2019 08:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190507152713.27494-1-sebastien.szymanski@armadeus.com> <20190507152713.27494-2-sebastien.szymanski@armadeus.com>
In-Reply-To: <20190507152713.27494-2-sebastien.szymanski@armadeus.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 7 May 2019 12:34:48 -0300
Message-ID: <CAOMZO5Ca7tZAb0vO8ZM1oKR2UXNV_KqcJ7oxeiV3kkb7=2jQBA@mail.gmail.com>
Subject: Re: [PATCH RE-RESEND 2/2] ARM: dts: opos6uldev: use OF graph to
 describe the display
To:     =?UTF-8?Q?S=C3=A9bastien_Szymanski?= 
        <sebastien.szymanski@armadeus.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Thierry Reding <thierry.reding@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi S=C3=A9bastien,

On Tue, May 7, 2019 at 12:27 PM S=C3=A9bastien Szymanski
<sebastien.szymanski@armadeus.com> wrote:
>
> To make use of the new eLCDIF DRM driver OF graph description is
> required. Describe the display using OF graph nodes.
>
> Cc: stable@vger.kernel.org # v4.19

The Cc to stable applies to bugfixes, which is not the case here.

With such tag removed:

Reviewed-by: Fabio Estevam <festevam@gmail.com>
