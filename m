Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2008A37BC7E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhELMaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhELMaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:30:08 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256A5C061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:28:58 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id c5-20020a0ca9c50000b02901aede9b5061so18708440qvb.14
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+AQTpNeBGOoeX2gbfwzdgXLRL1J2RrfI8xvj96/f0U8=;
        b=XD2guawc7GhVI7/e/1f6Y3/+A2InuDR4byTTurz4sYAddmjPIw7417Xwfd7m/FNE4t
         m0BZCRyak22VYxupCrngNwO5l0HRkgA7BPkhhQd7BytyKlfWcFy8njuOaSCLdRxGFPdi
         JaYeRJZGrX/qFrnisScza3kcIS1anSY4qN8cNl6CrVpmORvdqPqSwGpzFvstqJUpXxLC
         HN3uU4jGeFzxAgwFQWABbE4iPUgxqq2QWKCKyHOFs8z/YrArY5nrIhimaU95qylqCYS4
         ia+4tKmdPhx2CIi7KVAHUz+L8nX+0D3m2WJAKmARy5iyn6hSh5JOvBgMDYKOAaorxIuN
         j0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+AQTpNeBGOoeX2gbfwzdgXLRL1J2RrfI8xvj96/f0U8=;
        b=T9biPu8ruJjEN3TKVlrxGPH3bHwau70XwI/dM0YOuxCBfM4B6jAfe4r1zeaC3NAetS
         eYn66p0oMr+QOR5jTi18MLnc/Es0sRia0IARUgZhRAeWxKXy651wjcorUm+fxheRcSOY
         AuEox+FNLMNUOrsCfwsg0wODqPKmRGoN/8HGZJQXzI0+G6iLaTM0g9Wv/Oq8nNo6G3A3
         8iRyV5gW0B+0oKinagVFLwbQ7kcG0c8u7z2yWubvpOKI3C0zZjhnAT/+yy3N684bUTxf
         mS/24kPtP9bokxsX1whC+GJxq8+y+ZHSW7o/LaoRJBaS8mOhmL7aVZZ2J+LTXHywz+90
         fZsg==
X-Gm-Message-State: AOAM530S/id8Q7ilMG21/d/1C9ZUz8WuxcVuH8h1QYrcsVkBpIP6nQKv
        pkXgOMoffHxzvC0q632FWNR1GohKiunThQQVfmmpugEUUGR9RoY+Mlsht6TOThGFjHeTb98A+gf
        bir+7q+HOMzJBBWaU7E96g59dn1zAgg0oe1k2A0VmllOg0LQYtbVmNGiB6pIiMiw4
X-Google-Smtp-Source: ABdhPJxysQKjEpY84vAZUziQqrHOiXOv5XlntyNSlcNO5VEvt/SxAzlf0ZpVaLgX5/WEDo8hI4+rx2PmyNyt
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:20e7:: with SMTP id
 7mr34549701qvk.36.1620822537494; Wed, 12 May 2021 05:28:57 -0700 (PDT)
Date:   Wed, 12 May 2021 12:28:51 +0000
Message-Id: <20210512122853.3243417-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: Revert memblock backports with missing dependencies
From:   Quentin Perret <qperret@google.com>
To:     stable@vger.kernel.org
Cc:     alexandre.torgue@foss.st.com, robh+dt@kernel.org,
        f.fainelli@gmail.com, ardb@kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

A breakage in 5.4.102 has been reported [1] due to the backport of the
two following upstream commits:

  8a5a75e5e9e5 ("of/fdt: Make sure no-map does not remove already reserved regions")
  86588296acbf ("fdt: Properly handle "no-map" field in the memory region")

As Alexandre noted in the original thread, the backport missed
dependencies. But since these patches were not really fixes in the first
place, it seems preferable to simply revert them from 5.4 and earlier.

[1] https://lore.kernel.org/linux-arm-kernel/CAL_Jsq+LUPZFhXd+j-xM67rZB=pvEvZM+1sfckip0Lqq02PkZQ@mail.gmail.com/

Quentin Perret (2):
  Revert "of/fdt: Make sure no-map does not remove already reserved
    regions"
  Revert "fdt: Properly handle "no-map" field in the memory region"

 drivers/of/fdt.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

-- 
2.31.1.607.g51e8a6a459-goog

