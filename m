Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCB93686D1
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 20:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbhDVSzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 14:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVSzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 14:55:51 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A729C06174A;
        Thu, 22 Apr 2021 11:55:16 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a5so16083508ljk.0;
        Thu, 22 Apr 2021 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I43MDT/4gAbtWwlihJ3mHIvjj3Y/M26LvMzUi1efgUY=;
        b=vdI4R2FP7yHLFU9m2C01Ek5+PqDZvLCFFV8gsOCoi+N4Hr3/lVqIGjXBXZrzgKiIsP
         T8l8TzMZipVEmkX43o16utrBo355zl3cGFwXK8KH1NFXDgwhHR6aL1k+61cvhr2o2Ej7
         +mVz4iG3nkBJAqW0mtMkOAEBRPgu5+pb7HGCelq7eLQtdqHrB5XsUxWHnLaeB5YAYDJQ
         mYGHZr8quQuPjWDBLAcw4wBOk3nIDreGonIsoDwBden65sv7oYK4mmymvL8YYL2RelWw
         hzRzrJIDaPdzX1Ps9D350oH2xxu6LBmY1QZsDGsiT2hcoD8MckrI7hnr+BLKv6J9LAyP
         slQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I43MDT/4gAbtWwlihJ3mHIvjj3Y/M26LvMzUi1efgUY=;
        b=EGVvJ5t9YrTZc1TV2lOU4tlYNyj/BCTerpWkN1EFGE48tA/tXi8sdgk8AXE8JXmOni
         KEGcefQnN0IO1Xb+PPyBfyC0wumn5GGw+Gr2JSNP8o10o3FBEJ9C92Ou4XvRQ1mO61mI
         Kirz1pvFy8XjgwSHtgSjira6Wcl60AzsUFFSW4VSXBnl1O46t8a4AX/17D8nDJBgXHx9
         BAExllc4N/hTpR0smB42F6UaTDnMc0YeqCULntinSh4STz2zHCn77HF8q5lchO2iSVeE
         Izi8gxw4ZLoCoT1N5PJ4EOkvJ7ojDpHU9kJCS6J52Jca2oo2qOVfa0RjYGZCm6uLyrO0
         pJcA==
X-Gm-Message-State: AOAM533O5p2i6ftz/sovbITNep0TUvG2Asbj9dz2OSpvcgThYtbHFzLI
        WHySvaJ57QIEbIDayIgqUWJAyrEhissMHp0bkAY=
X-Google-Smtp-Source: ABdhPJyMQuqDEQ+rl5JGM/TJjvEw0vHbxW8I+fWGTaD4kxtT+pL7kixLKZZM2c8A2IWRLGG0qVKAxA==
X-Received: by 2002:a2e:90d2:: with SMTP id o18mr179885ljg.288.1619117714738;
        Thu, 22 Apr 2021 11:55:14 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.147])
        by smtp.gmail.com with ESMTPSA id u8sm332634lfm.133.2021.04.22.11.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 11:55:14 -0700 (PDT)
Date:   Thu, 22 Apr 2021 21:55:11 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Atul Gopinathan <atulgopinathan@gmail.com>
Cc:     mchehab@kernel.org,
        syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: gspca: stv06xx: Fix memleak in stv06xx
 subdrivers
Message-ID: <20210422215511.01489adb@gmail.com>
In-Reply-To: <20210422160742.7166-1-atulgopinathan@gmail.com>
References: <20210422160742.7166-1-atulgopinathan@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Thu, 22 Apr 2021 21:37:42 +0530
Atul Gopinathan <atulgopinathan@gmail.com> wrote:
> During probing phase of a gspca driver in "gspca_dev_probe2()", the
> stv06xx subdrivers have certain sensor variants (namely, hdcs_1x00,
> hdcs_1020 and pb_0100) that allocate memory for their respective
> sensor which is passed to the "sd->sensor_priv" field. During the
> same probe routine, after "sensor_priv" allocation, there are chances
> of later functions invoked to fail which result in the probing
> routine to end immediately via "goto out" path. While doing so, the
> memory allocated earlier for the sensor isn't taken care of resulting
> in memory leak.
> 
> Fix this by adding operations to the gspca, stv06xx and down to the
> sensor levels to free this allocated memory during gspca probe
> failure.
> 
> -
> The current level of hierarchy looks something like this:
> 
> 	gspca (main driver) represented by struct gspca_dev
> 	   |
> ___________|_____________________________________
> |	|	|	|	|		| (subdrivers)
> 			|			  represented
>  			stv06xx			  by "struct
> sd" |
>  	 _______________|_______________
>  	 |	|	|	|	|  (sensors)
> 	 	|			|
>  		hdcs_1x00/1020		pb01000
> 			|_________________|
> 				|
> 			These three sensor variants
> 			allocate memory for
> 			"sd->sensor_priv" field.
> 
> Here, "struct gspca_dev" is the representation used in the top level.
> In the sub-driver levels, "gspca_dev" pointer is cast to "struct sd*",
> something like this:
> 
> 	struct sd *sd = (struct sd *)gspca_dev;
> 
> This is possible because the first field of "struct sd" is
> "gspca_dev":
> 
> 	struct sd {
> 		struct gspca_dev;
> 		.
> 		.
> 	}
> 
> Therefore, to deallocate the "sd->sensor_priv" fields from
> "gspca_dev_probe2()" which is at the top level, the patch creates
> operations for the subdrivers and sensors to be invoked from the gspca
> driver levels. These operations essentially free the "sd->sensor_priv"
> which were allocated by the "config" and "init_controls" operations in
> the case of stv06xx sub-drivers and the sensor levels.
> 
> This patch doesn't affect other sub-drivers or even sensors who never
> allocate memory to "sensor_priv". It has also been tested by syzbot
> and it returned an "OK" result.
> 
> https://syzkaller.appspot.com/bug?id=ab69427f2911374e5f0b347d0d7795bfe384016c
> -
> 
> Fixes: 4c98834addfe ("V4L/DVB (10048): gspca - stv06xx: New
> subdriver.") Cc: stable@vger.kernel.org
> Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
> Reported-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
> Tested-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>

AFAIK, something similar is already applied to linux-media tree
https://git.linuxtv.org/media_tree.git/commit/?id=4f4e6644cd876c844cdb3bea2dd7051787d5ae25

-- 
With regards,
Pavel Skripkin
