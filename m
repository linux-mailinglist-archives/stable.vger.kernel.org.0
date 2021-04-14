Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FEB35FBC9
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 21:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhDNToe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 15:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbhDNToc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 15:44:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF03C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 12:44:08 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z1so25128091edb.8
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 12:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Xng6G6CbcRURpv8RIL35ghrG4IbvLgdLxRkjo9QwSxo=;
        b=Hc5q6f42oSMiQkyb0/ONerkh9QQwcuXw/srWtIZzKeJ6/WmKJP9XXp9tGbfANJcWd0
         24q9zs0h+B6cek6KYgWN2npd1btIXdEgbTk+ZZrJY6RntN6C1GSrWLuCwg0XpiWODNQ8
         +D1uboHMdws059Bq8OTZvhTSg1Ik/45JJKKRjd9m5TeJv6XOB0YdjGelX3ziuZNGhUtK
         aqkpL9+wMA2S+xTGLFux7105o0MyGwMdMngjEhmw/CkiRvCS7I2HkJOeW26bYgSeFM5e
         N4sfrzLF44ZJM5tuhRkwW0y72wP9zsMqqc+LdI5vFWIDXiEU4NZiKvQfucTA8e8QHRnP
         qzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=Xng6G6CbcRURpv8RIL35ghrG4IbvLgdLxRkjo9QwSxo=;
        b=e+AB/GadWdqR6mHdoa8RgT6y+XCAal6DH7odAWo/4F5ir29RNVDGi50xLNLMV/xu9L
         roQXJsu1OFdz3VJdxoBFJ1/nvL6n/G78Rho4JI88LNrSydz7h69ooMli1fG4lRkAudxX
         XA8SQEFA81Mm/9vsym91hw+EX87vFCj3q9FMWlJ4kS74i+kO3L+Gg824raqIE53UpxDE
         Dih+jAU3bQXlnlFuJb+i3raldbHspItqIbTvyFW6k8UQ+mAxZsMkJzwomdvgy4gEsJ1x
         BbX6t1ZQF4cRs3hv1q93BOVe6ZEMzDar4zNjsDtOmMKl/7xp+tNlBRXlut8DgigKut2O
         y9ag==
X-Gm-Message-State: AOAM533byj+293rf8O9sbNRIKwwQE87Pb6cG5/k8JJf4EYrBmmgbknj2
        xKtTV/yZE3QFkVE2CSjuXJw14dRP/HEl9sNuhIw=
X-Google-Smtp-Source: ABdhPJyv1mewdtF4GJwFo6VK7X/yUlcDNecDAWR58fXl7BXW0uzvkfeR5cWFQ1mycHcuAklgH7t/ZQ==
X-Received: by 2002:a05:6402:5211:: with SMTP id s17mr545969edd.327.1618429447393;
        Wed, 14 Apr 2021 12:44:07 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id q2sm291605eje.24.2021.04.14.12.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:44:06 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 14 Apr 2021 21:44:06 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        NeilBrown <neil@brown.name>,
        George Hilliard <thirtythreeforty@gmail.com>,
        Christian =?iso-8859-1?Q?L=FCtke-Stetzkamp?= <christian@lkamp.de>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Sergej Perschin <ser.perschin@gmail.com>,
        John Crispin <blogic@openwrt.org>
Subject: "Backport" of 441bf7332d55 ("staging: m57621-mmc: delete driver from
 the tree.") as well for older stable series still supported?
Message-ID: <YHdGBm2WHb5I8FFW@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha, all,

Prompted by https://bugs.debian.org/986949 it looks that files with
prolematic license are present in stable series in
drivers/staging/mt7621-mmc/ prior to 441bf7332d55 ("staging:
m57621-mmc: delete driver from the tree.") where those were removed in
5.2-rc1.

As the license text at it is presented is problematic at best, would
this removal make sense as well in the current other stable series
which contain it? The files goes back to it's addition in 4.17-rc1.

So it would remain v4.19.y where the files should/can be removed as
well from the staging area?

Regards,
Salvatore
