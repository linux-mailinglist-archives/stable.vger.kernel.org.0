Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7E53C6FC
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 11:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404634AbfFKJGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 05:06:04 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:32822 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404619AbfFKJGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 05:06:04 -0400
Received: by mail-ot1-f67.google.com with SMTP id p4so7925914oti.0
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 02:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rwXJ0N12YFLwa3eVVBLbd7agid8j+bBmrKd/BuMAQiU=;
        b=DsUPLa7LCfch9zRy/io0G7X75mksebnmHPsCdAHYt9k7o48Xp45CvOqTXFWAuZSz7P
         9ghAVBrDBjTT9piadvsFYmZiLgAcunqzMT49u4pChgIOR4ziZN03szKDxIgf0BcKs14x
         f1wrIQFRbwDDw/NH60x4yMljZyH2If4elyyVw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rwXJ0N12YFLwa3eVVBLbd7agid8j+bBmrKd/BuMAQiU=;
        b=XZ8c9n/Y3jWNKMvpraqKupn46mf5ETl4c+YYtkbi+WDOnd5Ws8lG4g/QtgJQl4LVNi
         ynt7HO5G5QvDTC/qhq2rGLCY3OTmsEIoKBbj9szNc8UIvE1UBMM6WcwnF5A6zkonuqjB
         /SePBSssq02PRFYgpTjjTwAmyFsoNZ+eYUZFny8zMoF61YTPZbn+XD9f3oFIrq6TureE
         VpO0/wenBrPIN3y/pVP8AnwCDvVfEEbMBVwPLksa8J8MsuqdC8HBkLlZCPBc1wCMyadU
         X6Mg1voFrZWMcX5NeuUtiDOztKYQ04saJY68q+8rFuv7/55EeTUkq4FQSHwbVJxmqnXT
         cWuQ==
X-Gm-Message-State: APjAAAVFColldgD8SbA8tT+sTE56a+G+hg0VBmjCs5rsBiLN8NP24WkU
        MZgMglySzEFTeb23//8MDH1HpLFFBjM0NKUUkY1WNKr8TVM=
X-Google-Smtp-Source: APXvYqwt5kZU7hIpkWm84uXzdUMrPiTBicmCiNGzeSrhCoNIMPJy4+6RoWMUsldwEhyEIw/4xp2QBOwFT1bi+jIWYPo=
X-Received: by 2002:a05:6830:4b:: with SMTP id d11mr32393993otp.106.1560243963973;
 Tue, 11 Jun 2019 02:06:03 -0700 (PDT)
MIME-Version: 1.0
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 11 Jun 2019 11:05:52 +0200
Message-ID: <CAKMK7uHXF-ZyVjz1UTOZvSn_TxXMFwjiDz8cYGmwzzpWHNcTyw@mail.gmail.com>
Subject: 5.1 backport request
To:     stable <stable@vger.kernel.org>, Dave Airlie <airlied@linux.ie>
Cc:     =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@amd.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable team,

Please backport dbb92471674a ("Revert "drm: allow render capable
master with DRM_AUTH ioctls"") to 5.1, we accidentally forgot the Cc:
stable and Fixes: line for that revert. Thanks to Michel for spotting
this.

Dave, for next time around there's $ dim fixes $broken_sha1

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
