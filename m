Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2750946AEC9
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350606AbhLGAKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhLGAKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:10:02 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584EAC061746;
        Mon,  6 Dec 2021 16:06:33 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x15so50109822edv.1;
        Mon, 06 Dec 2021 16:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WE5bBeb2eJPuT7PslF4NZOlF3ypIGd3g2CFf+WxsT0Q=;
        b=nCAbv9dYTiu7R7wBMuoluTGvEHVh/pa+nuZ+TzNCsCH3gvqo2S8laybaR7RnRfFhcA
         YTrmTgGzyBVD/ESScn5yhz3XC3zalRihRlUtqmM170jvAsdpx8K9L1rEpOK/zhPv/gBu
         EEk/FVySij9rFcAeexN5+I0hn0efAAVkqsF+Q1UG8l8Dn8Ywda6XRm+Pah7ta8BQhrIu
         LBXKRv6Os886hZ23jbO7KebqZMgf3PncE4mh0MTRz+JVjFoSlGdTraCjwqwpxBTETGpX
         gbemYfYAWofdYWViuhxek5tRr1AXiMLISInkw3pWOkzOSQ4gVwkYqE8FZv5yYXpYglMd
         ZUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WE5bBeb2eJPuT7PslF4NZOlF3ypIGd3g2CFf+WxsT0Q=;
        b=3hwzFh/sUQHUCGcrA+oF5Eg8QbU+pKbydX2ILR5rvgLJgTtBrVdRJgtz5QzPZtIyt7
         ifQ49rN3BE/BazU2aNMj59F1udDkjIfNUOTI2dQUzXMvzOnVi0F/doWpIxjKAIB00L2R
         6Z5qHasdKiKUID+TeX+lI1+d0wJ5zLM1Zvy1tTTAxQqLFZyxFpgFim6yT3Bsa2NyMIiu
         FEPZPEO5QN1+uXOC+utBiKK/Qfp7V3V2YsY2LqfqRE069vmakFW2ctYJmdbQB4anAVP5
         9WBNu+N1wogsF1boMPVBcyrJNkJ9srD4gUCk5f04ZhnaUpuwjQuv5JHMJGxLWUK/ZMSN
         sWAA==
X-Gm-Message-State: AOAM533hiTra2r4/mETVBPfHfDWADBla30zogPe8nnasU3TQGxzBatdp
        8UBNXRYRaKTfcrOevbHs65Y=
X-Google-Smtp-Source: ABdhPJyJys3GJzGuaRjK+svI92HIk1yspjaRXFUhn3v++hGz42nWP3Dx9+5GbBCTwYlgz1QvXoez3g==
X-Received: by 2002:a05:6402:350e:: with SMTP id b14mr3583797edd.313.1638835591792;
        Mon, 06 Dec 2021 16:06:31 -0800 (PST)
Received: from piling.lan (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id w18sm8713114edx.55.2021.12.06.16.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:06:31 -0800 (PST)
From:   Ricardo Ribalda <ricardo.ribalda@gmail.com>
X-Google-Original-From: Ricardo Ribalda <ribalda@chromium.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ": Ricardo Ribalda" <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: [PATCH 0/3] uvc: Restore old vdev name
Date:   Tue,  7 Dec 2021 01:06:26 +0100
Message-Id: <20211207000629.4985-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to have unique entity names, we decided to change the name of
the video devices with their functionality.

This has resulted in some (all?) GUIs showing not useful names.

This patchset reverts the original patch and introduces a new one to
allow having different entity and vdev names.

Since some distros have ported the reverted patch to their stable
kernels, it would be great if we can get this sent asap, to avoid making
more people angry ;).


Ricardo Ribalda (3):
  Revert "media: uvcvideo: Set unique vdev name based in type"
  media: v4l2-dev.c: Allow driver-defined entity names
  media: uvcvideo: Set unique entity name based in type

 drivers/media/usb/uvc/uvc_driver.c | 14 +++++++++++---
 drivers/media/v4l2-core/v4l2-dev.c |  4 +++-
 2 files changed, 14 insertions(+), 4 deletions(-)

-- 
2.33.0

