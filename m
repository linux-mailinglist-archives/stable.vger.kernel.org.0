Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E00248DEA
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 20:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgHRSZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 14:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgHRSZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 14:25:17 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B86C061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 11:25:16 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id c6so18436685ilo.13
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 11:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sBiGA+D8K9N6uRPEo/wqJn6gvDXiCxCVaaYOfU6ZPgo=;
        b=EVOUUuEL5jPAFfrarwF8nNbNGca4UF7/E7GFso3Lhgxpe9A9fHiGwR8HAeaZz/Q/7v
         2FRQaj5pcM6YrnKtwveQrVJfNc/J6S0TIjKaTNhAERTx4t94uDwklbnvHYNaFDII6CAS
         yeUgI1Ac+Ic/DrY6mRwXXg8/UDB7oO9a3zvztEVtAKrcvHk4Urz3/fQvSmEAzn5L6oaQ
         qc4B710OHStXVUr3YnrH9ltpfxY81Xr2EMhgyD+Zag2YK6msziEudhUXVplSvazqTnLh
         e9p3Ul3sc9po+JxVlqShzDzgCSL/q4FKzLo+SY1mc2RpdE7fv4zUL/TqHO2MZaRs9oRn
         hvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sBiGA+D8K9N6uRPEo/wqJn6gvDXiCxCVaaYOfU6ZPgo=;
        b=o0UwlrDgMoN4Ng/KCHRAAzV0PYFm4PKIShOYqk61dTlpmKy2L2K47OiaTNy7Ys+vlD
         lEhnbrslIxDlMPHtXIZzxg6KNGSIJe1mGCnljxk/I57I0Hd676k+GDv9tC9/k9wq4dGC
         IEZjB72Oj+pachxXOx8JNlVZYbQs2J79cmaIrbSw7JG34KHYlk1lTTbRZCC7me3/cRat
         kT+1nCbN4+ofDfW9VNqQU2RAh+qLQppmlrlcVsDzAVRnMj2mZcizYclhT7fVWy6RMqur
         TjUGsDUnxlkwHdQdGTqJ67dhnBSWzB+WH8DgBqwsIWkZ2dMFKFjRmBW2dcYkx+5oQYwJ
         17zA==
X-Gm-Message-State: AOAM532/BHh6nK4+so75EONWrf+4tImWPpVnE+CW7QYabFND7bQTN25V
        Wb4AAAKoSRODnTvUzAr7Jb8XGvQNDRivgNA0SYI9t5lawxgvpA==
X-Google-Smtp-Source: ABdhPJxILD1cFElvZJpXAH029J3fTjHQHN/95/O+9f1NTIk86GG3x01u5tnDYVFN3R3hZHfaqMMOI4ZVRRmKHFzifmI=
X-Received: by 2002:a92:9151:: with SMTP id t78mr17898655ild.65.1597775114872;
 Tue, 18 Aug 2020 11:25:14 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 18 Aug 2020 13:25:03 -0500
Message-ID: <CAHCN7x+Y52_cpJgRe9nSJYMXfHFkggrjgriMgtfqw9=CQ2Qyvw@mail.gmail.com>
Subject: thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 0f348db01fdf ("thermal: ti-soc-thermal: Fix reversed condition
in ti_thermal_expose_sensor()")  Fixes an issue that was introduced by
accidentally inverting the check which disabled the functionality.

The issue was then backported to 4.14+ kernels, so they are also
affected and this patch fixes the regressions.

Please backport this fix to kernels 4.14+ to restore functionality.

Thank you,

adam
