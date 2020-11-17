Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD83A2B5C6A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKQJ74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgKQJ7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 04:59:55 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E92C0613CF
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 01:59:55 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id p12so23565770ljc.9
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 01:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=oZCTdQL04X3RK+5B9ztMFUlnmEjRORrfVkH2NnIfNeG2qz8I1M38bL3BeWJY5nK/Ae
         OQaTfw0xAO8AMcldiPA5p0cGQCz6lYayu2kLm/66Y+W+ojWYK5c1XYKfT/qf7ygAq6X7
         Epp+Od4YDWe1ca6fvfe50FW4CgvHJusLu0Tem8gGMPvmCrIssfFaix19OZVCYxvbv0dN
         QkwdlJ2sxne3J1TzI7m6yQS5/CHU5R9Bn7gQ6YX7yAF/ZILezuFGPzB760aVspMhoUym
         R9hi4FyQuywa0F5/K05Xz0itRR5wyPf0c9WfpD5AwX4iSglnZIZBXxZGJOIOxZgTclqo
         Y56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=p/qX0K5GgRwQcqK6w7vfvg9JwOfpoxjUuccZvI0PR81BiJ6Qy+Ci9HY8PE2SB+mk7I
         iHHJKjop01wwJL4oyuaRXdGl6IqMtPDa5ok2RlCXS7hN4DnIgNFY2enVAH0HwUO+16M9
         bL7t2sYIgEErGFV+WkAJiU/f7sHdQ5NpuaBhdUdahPf+/8AAJ76Z1BTsyZgyWtSZK4Pi
         TZJDNCybhJA/C3wd8YUYYwTY46a/vLr0RDfCdtETCPM/uPXsEitc9r1/89p2fsOGjoiG
         49L6YFN9s+u7qIdIRcN1hkpiBQqJnmONEoJXlNG/3pORW1qL3Ey+XvviregqYAr8ihlC
         3oaA==
X-Gm-Message-State: AOAM531K2Gf6vImrfe7mEHndXYaq9boiotyOB/JOklM2mZz4xeTqgmeY
        Lo6dV8A1/CHfNOflbTV7mxsOfy892VJS527OoA0=
X-Google-Smtp-Source: ABdhPJx1LyihKVqQpPGkM7+J35KxsjD4GxDJcueLSYfh4EfybMp5hbxamUEBkgJSxYE+A8LWp5flhS0rTFapeDx29MQ=
X-Received: by 2002:a2e:8753:: with SMTP id q19mr1496296ljj.188.1605607192938;
 Tue, 17 Nov 2020 01:59:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a19:cb03:0:0:0:0:0 with HTTP; Tue, 17 Nov 2020 01:59:52
 -0800 (PST)
Reply-To: maggie228lesnar@hotmail.com
From:   maggie <chechec045@gmail.com>
Date:   Tue, 17 Nov 2020 01:59:52 -0800
Message-ID: <CAMZD7SFDz65240hpJCEe4Tjyd+k44FLifq14JBN_3HqeWnZhNw@mail.gmail.com>
Subject: hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


