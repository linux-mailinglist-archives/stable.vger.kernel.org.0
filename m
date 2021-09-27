Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CD2418E10
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 06:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhI0EBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 00:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhI0EBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 00:01:55 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07111C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 21:00:18 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x7so48842299edd.6
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 21:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=P6hcjUDgNRVWoQlF2WjLd9MJ396DFb3R2r9u5EtGSlM=;
        b=PpPKSqYALq6HCMy+CYvhkeiz/pSD9t2jmdWsjbqcZj1mQn6QkVPB+NbeUvLY7Zw11x
         0o8jkaYotsI/RFVy6+9jRqoPif8j5NZ0MVHJwRnBcwgFrPXMtCEWt7PfPuIlysaocNK2
         Zw5UqPs+h58ZoySo7nk71to+g7PwcXCf+Jn9m3ADozsPv26PUNXeFupJ0B0J9Io7j6he
         1kMWzipHr/AVUFvmoz7ogg5BvcsZmRd+95E+rYfWcdorqvmk0Z2Lm6ARf6ydQ1y0hSBi
         A0DvNX0aAU4TM7zR7S7tMYXm+Pft2AGLgkiOjHjYSGOBGixmKy90h5pJ2xnxsx77bhyn
         rerg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=P6hcjUDgNRVWoQlF2WjLd9MJ396DFb3R2r9u5EtGSlM=;
        b=RpKJZP/QhKHK8Ykc0MRVvsmBgkipr53t9WN3LG+5fDWxT2MO06ZiZxGr+b+Oasil3O
         gqtCtt+5y9XJZcbbLjzmEHG3OB28PCSngiZBXoorinxINi6BJrIRP/dVp9ROCuxrVbaF
         3AqQXRMSGt+YY98mOt/m8evq3xUxKlzGIisvcZ0iejZ5Wz1QKpwt32S/etm1p1bL1zjN
         /j9hr/+xx7RiRDYs6yOLLyWtpXjXxPQmXjx5UhkECSgH20v3UdqxVObTQQhF/WM7p6Ma
         UPzCtqij9hpLNLKV60/pOgMQ0+ktfxtsxHVFaY2jwAPbdjM3lMyDVrusF7rR0XS+muaK
         Qwww==
X-Gm-Message-State: AOAM532UM3gHeCE6VJgnWBhPXLXMyE974hF6wSAya6/+v4zzOl677c4m
        vu3pVDa0IOyz87DYRjghvlAcTB2wGwjsf/tieWc=
X-Google-Smtp-Source: ABdhPJwoe+UE6p+agWiOsCvE4hJGL5QoAbo8dV+0WzMS5BQfnyVRDlANn6IZMtn3+8Gzm+iwM/LbvDVxaI9G3ii49H0=
X-Received: by 2002:a05:6402:21c5:: with SMTP id bi5mr10298499edb.367.1632715216552;
 Sun, 26 Sep 2021 21:00:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:a416:0:0:0:0:0 with HTTP; Sun, 26 Sep 2021 21:00:16
 -0700 (PDT)
Reply-To: asameraa950@gmail.com
From:   Samera Ali <hasamuhammad24@gmail.com>
Date:   Sun, 26 Sep 2021 21:00:16 -0700
Message-ID: <CAEsd0fnf2wV0BvuB+WN1ar2z=Oeih-xSRw7v58a8+30KGfRrpw@mail.gmail.com>
Subject: =?UTF-8?B?0LTRgNCw0LLQtdC5INGB0LrRitC/0LA=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0JfQtNGA0LDQstC10Lkg0YHQutGK0L/QsA0KDQrQn9GA0LjRj9GC0L3QviDQvNC4INC1LCBBbSBN
aXNzIHNhbWVyYSDQndCw0LzQtdGA0LjRhSDQuNC80LXQudC70LAg0LLQuCDRgtGD0Log0LIg0YLR
itGA0YHQtdC90LXRgtC+INGBDQpHb29nbGUg0Lgg0LjQt9Cx0YDQsNGFINC40L3RgtC10YDQtdGB
INC00LAg0YHQtSDRgdCy0YrRgNC20LAg0YEg0LLQsNGBLiDQmNC80LDQvCDQvdC10YnQviDQvNC9
0L7Qs9C+INCy0LDQttC90L4sDQrQutC+0LXRgtC+INCx0LjRhSDQuNGB0LrQsNC7INC00LAg0L7Q
sdGB0YrQtNGPINGBINCy0LDRgSDQuCDRidC1INGB0YrQvCDQsdC70LDQs9C+0LTQsNGA0LXQvSwg
0LDQutC+INC80Lgg0L7RgtCz0L7QstC+0YDQuNGC0LUNCtGH0YDQtdC3INC80L7RjyDQuNC80LXQ
udC7INCw0LTRgNC10YEsINC30LAg0LTQsCDQstC4INGA0LDQt9C60LDQttCwINC/0L7QstC10YfQ
tSDQt9CwINC80LXQvSDRgSDQvNC+0LjRgtC1INGB0L3QuNC80LrQuCwNCtC80L7RjyDQu9C40YfQ
tdC9INC40LzQtdC50Lsg0LrQsNGC0L4g0LrQvtC70LXQs9C4ID8/IFthc2FtZXJhYTk1MEBnbWFp
bC5jb21dDQoNCtCe0YIsIHNhbWVyYSBhbGkNCg==
