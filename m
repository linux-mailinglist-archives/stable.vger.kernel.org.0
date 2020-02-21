Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABD916793F
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 10:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgBUJVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 04:21:38 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:38016 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgBUJVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 04:21:38 -0500
Received: by mail-ot1-f45.google.com with SMTP id z9so1420726oth.5
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 01:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cqmf432SPqQKfwBHXpPoUrqxT+kYpTdppomS3O+LCag=;
        b=Nlld1Llo28/VqKZINCqZk+3EkkcyszUUMCjBc19XMfGitfMNWv3e3Si1MQgOPNjm0z
         hwU5LGwg28rUD3XXBhvvsx71sUEmmCGErqhFTRAtYCx7iSQstEsyk5THt5SbiY1/G7TS
         GmQNRYMvULDdoZF28FTWmjRwGYYIegQ3GICkkR4JuiBqhQ5Qn7IjG729KdpI3IQzfvU+
         CK6wFttneTpQEStJECFpGWipK3DXaUKebgdpgU6hCfCioVyZvF6JyjsRFf07HB7Zmgla
         6+rQeBOab9kOSbkHUnybJJkNII1q92Zy00aqt43F3SPNfMi29+ttH2ZSCPIy42v2KwcX
         +z7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cqmf432SPqQKfwBHXpPoUrqxT+kYpTdppomS3O+LCag=;
        b=E/XS7oWpcKFtztgultDyPCM+8TE7kX4q6ZZ+5Lsr3MGf768BBkAL8KeMXV4g20ry2I
         FGtvfUbMDSnZsVuprTHI50pesP5gLw9HEgfhtuuj9TsV5xGRhnbFawhb2WI3/KT6aJ/u
         VdOR1baV2aKdrjSYhrOpXw35WRlBVExD+sK414bpJt0eq1Ox5erCgeCCezkrBbMURNs3
         vCFfQJe0pNsvPt+LimDrGm1ZGpcqvaoTqU+G8wHrs5z/mTu+NMuFl6nPH6OQNXNt1QfM
         Df1h9TGTVxfoqYPkw+9mxpAchzzAZ0DjP9gzSCJI2P4Ywn255qldQwbuRemxdxwEvggU
         pvQw==
X-Gm-Message-State: APjAAAVLDo8XKAX7twx+0lpqmjGKn5owyTS/vETajWv6IYKKcNNaAECH
        baJhJ5EZTYEKB5ZEhQBDPBB59UkfTsMWjbNkeQJ8njNWP20=
X-Google-Smtp-Source: APXvYqy33tngaoHRY0F0RSs1Nze131PwC37qrJq9JAkhP7C+UBQ4gtffGjYylPxYNQmhEWVXItRMBYnlk6Rja+pmh0c=
X-Received: by 2002:a9d:6a85:: with SMTP id l5mr28657449otq.231.1582276896884;
 Fri, 21 Feb 2020 01:21:36 -0800 (PST)
MIME-Version: 1.0
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 21 Feb 2020 01:21:00 -0800
Message-ID: <CAGETcx-0dKRWo=tTVcfJQhQUsMtX_LtL6yvDkb3CMbvzREsvOQ@mail.gmail.com>
Subject: device link patches on 4.19.99 breaks functionality
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

4.19.99 seems to have picked up quite a few device link patches.
However, one of them [1] broke the ability to add stateful and
stateless links between the same two devices. Looks like the breakage
was fixed in the mainline kernel in subsequent commits [2] and [3].

Can we pull [2] and [3] into 4.19 please? And any other intermediate
device link patches up to [3].

[1] - 6fdc440366f1a99f344b629ac92f350aefd77911
[2] - 515db266a9da
[3] - fb583c8eeeb1 (this fixed a bug in [2])

Thanks,
Saravana
