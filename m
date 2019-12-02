Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFE610F2B4
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 23:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfLBWNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 17:13:16 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:43657 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfLBWNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 17:13:16 -0500
Received: by mail-pl1-f181.google.com with SMTP id q16so621323plr.10
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 14:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OPbjPuTNYqlaMrWd+frcow5DVfKGUYouV5Khvapm3og=;
        b=eRmOJoVQehBNyN8m+gPrKeh0E2tqByM/JJgmDij2aEP6s+N8uKPmvs28qR4v8z2PEC
         TFN9bULmFckIQZeGOan63TSRndeSDDzAEyp65H603G9Q4RIo7Xdcp/yslOEgiCeIheVr
         B+YT3/iRE+O43UcbocbBDRSvjpkMaz8MKGQ25lP8S/7NepZqs3Xbw8LChA9iyhUdzP71
         37v11brZ4THBj212o12EQ6ljYO3DCub3qC4kOWeKpoeHYApYmJOuiU4kE9JuzxzMPxWu
         cjnM9bszAqhQ9uBHmnJiWPfVh+kBGjZpKgqJoJwaMalhZJWvWvCzyZQLO/R39iuXlyUV
         1cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OPbjPuTNYqlaMrWd+frcow5DVfKGUYouV5Khvapm3og=;
        b=YToofKv9T5Mmwn321fUoJ85F4FY0XUSW3fJg5X11at18qe8EhLXMYTdbB9bsRcqsEd
         9kZeNQwYLEbFnu6H/o1I9ifEqYiTIOPTKeO/WjlgnjAhy7sg3V307+paIFIgSlWfFLYf
         JU0JW/DrdToZ5+zfnmdjtVdfqlAsx1xNxxKk2FT/XI1l0skDGCrLgxQDllJAArxZZ2dQ
         lnd41NzoMbBUo6BN23IWcSohgS8e5xSspFR7mFwY2Za6GO0UhKv1zRICmo/RHzL/ZFOd
         EoV/VkZpGJ2qwhq3GnnybR2UwQDzV0T4pt9Rjm5IOFRlajdVWGD9fwBnAuqn/oHEEEFO
         +Qyw==
X-Gm-Message-State: APjAAAVrJ2u6zaOLQa8ztvyPi2IvhZ7Hj8Q64gQqtBHxW7imLEncXI5m
        EN1THUOEx4Q0Y8XWt8qjiBV1vtcybSc=
X-Google-Smtp-Source: APXvYqyBDaBe50Ennf1lND3R8F0f/5onxuqh27tmCE5QRQWmolNfRF65zKW8hWzJdg/kFEX+L3wGkQ==
X-Received: by 2002:a17:902:d88a:: with SMTP id b10mr1481285plz.302.1575324795440;
        Mon, 02 Dec 2019 14:13:15 -0800 (PST)
Received: from localhost.localdomain ([2402:3a80:13a5:68f8:8c79:ade:52de:6e5a])
        by smtp.gmail.com with ESMTPSA id 83sm613223pgh.12.2019.12.02.14.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 14:13:15 -0800 (PST)
From:   madhuparnabhowmik04@gmail.com
To:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Cc:     skhan@linuxfoundation.org
Subject: Boot Test: Linux 5.4.1
Date:   Tue,  3 Dec 2019 03:43:10 +0530
Message-Id: <20191202221310.6189-1-madhuparnabhowmik04@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I boot tested Linux 5.4.1, everything seems okay except the following error:

[    0.275509] platform MSFT0101:00: failed to claim resource 1: [mem 0xfed40000-0xfed40fff]
[    0.275515] acpi MSFT0101:00: platform device creation failed: -16

Thank You,
Madhuparna
