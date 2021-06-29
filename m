Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928923B790F
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 22:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhF2UIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 16:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhF2UIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 16:08:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF14C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 13:06:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h2so32990603edt.3
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 13:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=r3vrQJH/EhY1087HK0kiWr5QK29B6+VW/R9z+IirfzA=;
        b=vhy+5sGbv4QVnv6n3dHUjE8xNblUfbaxthLTmNgG4BSiAXCkwDQ4eIg6yDlBsxAAZi
         oKES8LyCqC2jwdj2fT9vQSsgeILiCC/NyGCcdp1DYoFa7rqpeFFzs9VrdOxpylrNPZZ3
         jIx0yVzizqYaEmDp+j2SqpdIMgo9ZeXtuej5VutQR+wYPpRx75WxZc4NtzW1akwAxVJm
         RPuGByn0WK1ENix04D8ZtskOc79mo9HWW65BduXfVnEgceO3LeFibNVzoCgCtkwsvY/H
         3mZIeo301ov37FhXolvxbZ8oV8SvEZDin82g5sK5KLbMNTl3Lovjc8g8VUQxNH4jRxve
         iCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r3vrQJH/EhY1087HK0kiWr5QK29B6+VW/R9z+IirfzA=;
        b=ErUAxTAI31V/AhUC1tS2Ob8rwLdvwxysL+NZmo47si7vYJJCNbu3i7LPR8T5AeG2lF
         jmr7NEt9gUA1YDCnQ5iiI0fUbNmoaLln3YnQvfgwHcf4QdbZJ/yPO9WZgju7kmZB4zBo
         QxdkF+Gn270wKqTbGtZwMJqZ57vEe4EdaSj6yRiLzwNzCJVFlu05OoC1qF/ee4DWRamA
         C6kXwu2uabQhFRGpOYMZheMZU2Hr8sye8v8BtHoCjyXAN1Zt4mSwcYFCfSl7vEAjsF1K
         N9UlzcOerUtyvBbssDePE3yyJt0I/wwIrLyH5HthhPkxWSWc78Y5ZoCMqSD+67qjOsdU
         vG5A==
X-Gm-Message-State: AOAM531d3hmq+JuWcG690s+p3ojmho9LDtJDC+6y1V391DTyV7v2gRL+
        N3ITqPYkvTKY50o/JaJtoPsa6eU4hlf305l/wgy2NowZW89h/w==
X-Google-Smtp-Source: ABdhPJx1IC7/QQauqGPop/4r15ExWFyspEyOsgyDnadDo4v2OQFYPlXghLQh0lAebklCpO4lrEZL2HVdrhLq7juE2DI=
X-Received: by 2002:a50:cdcb:: with SMTP id h11mr22105358edj.366.1624997172313;
 Tue, 29 Jun 2021 13:06:12 -0700 (PDT)
MIME-Version: 1.0
From:   Anil Altinay <aaltinay@google.com>
Date:   Tue, 29 Jun 2021 13:06:00 -0700
Message-ID: <CACCxZWMREz1AVchULrWpdvtXYdDXJPNbC3qJicQ-S6UnfTbCUQ@mail.gmail.com>
Subject: CVE-2021-3444
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I realized that this cve(
https://www.openwall.com/lists/oss-security/2021/03/23/2 ) is not in
the 4.19 tree but the commits introduced the vulnerability before
4.19. Is there any reason that the fix was not cherry-picked to 4.19?

Best,
Anil
