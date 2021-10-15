Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C648942F73F
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 17:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhJOPuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 11:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbhJOPuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 11:50:19 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4C4C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 08:48:12 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x27so43838888lfu.5
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 08:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=KzpWrXZNvDmEz2eZbSasSqj1+9Uxu2H3QMUpmMIjAfs=;
        b=W7Q1ZgO8e3jp7Ic3ivjD66s48ytk38jyxJ9AB/gbzJKMq6jgeX38SvQhztnP+yPwsM
         JWQ1apH3hVo9tLPBCxB9yHyTBieAehoxE07EDW5bGTOLCDdrbNZCvh1P8BCwna4y+kXT
         l08+j0/H/uKmcbAE1F9pquLpsuZAJyVt7wSx7j23LHSd90y3l9gRngTFlxFNZoWbUnMH
         OU0IBErP8KYyKc/OvXASpAwpuGhEwwWgClsqpgZrtLfTsmFsWANwPm4D4WfNNCNBVQvI
         nFDBmXa1qKvmL6NkD8V69F+FsVHkT1m/OMBOfwpp3rLU3dwUnkJsPtpz5znj6Ug5K42p
         lycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=KzpWrXZNvDmEz2eZbSasSqj1+9Uxu2H3QMUpmMIjAfs=;
        b=JkMeIssDIMxxh6HLwoDA7xKIXYRvHOua+OCAk7XmREX3Et2mewIHK3hZR3SNasnw9O
         0nwPPh4u3RhwJh/LJUakLiwtefv8wzC6XeokQ+wXwutOxgNw4r5XFKpS1/k2pk/zIOxI
         ksn95GpjjQjEBT/87s5QXL08ml3ECZ+/OyR+AidY6VEJeNptf+2rJt3s1mjmApX0iXDt
         3NCZ/xO4MdLFYEjOTP7arMQwlxMEKB3CGDi6xD5FzLwFGruPLyJ8Az3I+VHbXTBOKRvI
         vjAoJcmsS184iWNNtVb3NNkU75af8qBcVSJN9SbOuPmKt1uutyOrPIj9u2Vl7KcdZuUO
         8PcQ==
X-Gm-Message-State: AOAM530dSHTcYfuhiZsVxeWwHBV+wuHtXm5JlmsSZjsnWAnpGjJX6hWD
        mZiwfe16MuhilHX5g145HaS85LJIPRVVqRaTPss=
X-Google-Smtp-Source: ABdhPJzfMPZ793vE+tTIE5FlZAJIY76kuZWQRjnqKeREa82S2X9yLt+FikiYp7Ww9kJHWgnxNrBlLF/aY1NRww+Lpus=
X-Received: by 2002:a05:651c:b28:: with SMTP id b40mr13955123ljr.334.1634312891222;
 Fri, 15 Oct 2021 08:48:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6504:1897:0:0:0:0 with HTTP; Fri, 15 Oct 2021 08:48:10
 -0700 (PDT)
Reply-To: donaldcurtis3000@gmail.com
From:   Donald Curtis <djatonamsate@gmail.com>
Date:   Fri, 15 Oct 2021 16:48:10 +0100
Message-ID: <CACrY9k3XSFdxXa=j3nktVz53dLG=rAHRKep7jxUtHHFjWm3Z5A@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SEksDQpHb29kIGRheS4NCktpbmRseSBjb25maXJtIHRvIG1lIGlmIHRoaXMgaXMgeW91ciBjb3Jy
ZWN0IGVtYWlsIEFkZHJlc3MgYW5kIGdldA0KYmFjayB0byBtZSBmb3Igb3VyIGludGVyZXN0Lg0K
U2luY2VyZWx5LA0KRG9uYWxkDQoNCg0K7JWI64WV7ZWY7IS47JqULA0K7JWI64WV7ZWY7IS47JqU
Lg0K7J206rKD7J20IOq3gO2VmOydmCDsnbTrqZTsnbwg7KO87IaM6rCAIOygle2Zle2VnOyngCDt
mZXsnbjtlZjqs6Ag7Jqw66as7J2YIOq0gOyLrOydhCDsnITtlbQg7KCA7JeQ6rKMIO2ajOyLoO2V
tCDso7zsi63si5zsmKQuDQrqsJDsgqztlanri4jri6QsDQrrj4TrhJDrk5wNCg==
