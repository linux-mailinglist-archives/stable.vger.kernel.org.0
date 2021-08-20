Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0566C3F2E23
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 16:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240819AbhHTOeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 10:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238451AbhHTOeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 10:34:16 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2D0C061575
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 07:33:38 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l24-20020a05600c089800b002e71a10130eso3007937wmp.5
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 07:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=RteN1kZyovWUoXzHMNLkP1o9koWxQbfuz3zdN58BpOw=;
        b=njGiwCkvJOfIW3/uEsPt/Lx9V3TOeANwJixQxoMhwi6Bnv2J4b9XOQambbZyBjCodW
         nQSbaMS8xLR0FG5tl+hrjGyj/GP0CtBl5Ldz10ZrfCOUQF7RVTIrj5MsUkacHSDRY9Am
         KZrR6s2G93Ym7BhArKBKreZf0kXMwoLKxN6gC85biDQXOUzl9KQ4w0SxvzG1C4a7P6Hk
         v8QfdTuMXZVkpuUj3XK6CCsTwVA9HIUKWD9rrZDfr+noNZX7OrMtPHMQeoQi/6urtwAQ
         vfVCAaiD9Bj77ZSwnPGMHkvMIBUP3BuxF5D6OFecmDrHb2+s071sIqtID1F2BvRz3RRQ
         935A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=RteN1kZyovWUoXzHMNLkP1o9koWxQbfuz3zdN58BpOw=;
        b=hVNjjQkYEtCcy3UypXknABfp79TpALLrXOfgmfaZXxKxxOXpf3wk2i98ks+BnTA1Rd
         7iSluGY/AQZI5pI8YQpvyBh5kcJKMPRMlOI53fE5jSwcD4RiW7Wu/2+8+wNwNQ4us2XG
         tuoVID3q5wW62+doDOgDWJAj7MYEJ/RZddRrDbaAExWQfMW0PB6AJE0lkx/3tzIDerIf
         nxyd9Wg098WjJu7KTNoeeHX7gm+yf0ZZVqGkVGloOjiRwUFovre5wcCQSiNUTohKcFSV
         vUEHUURgPoBSTRvULeLBxhm03CPJDz6mr/UF99EgSZgLMP7BMyinsvsDDhqb14B6l3uO
         B8CA==
X-Gm-Message-State: AOAM533Z30TMVoYRIQuvgQw3fja1ckg5b2+9+E0Hmqcfgskap4KE2X7o
        a4MJJkR23vyaHgOz2ZN9QN4=
X-Google-Smtp-Source: ABdhPJziJFuEV9SIC8q+RbaF9PgGNny8Cu3G6jPoymQ9ripC9+YLR8kfo3MHHWNjaHbmDQo1JrL4sA==
X-Received: by 2002:a1c:a90d:: with SMTP id s13mr4377648wme.132.1629470016955;
        Fri, 20 Aug 2021 07:33:36 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id h4sm6214999wrm.42.2021.08.20.07.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 07:33:36 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Fri, 20 Aug 2021 16:33:35 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Ole =?iso-8859-1?Q?Bj=F8rn_Midtb=F8?= <omidtbo@cisco.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Tim Connors <tim.w.connors@gmail.com>
Subject: Please apply commit cca342d98bef ("Bluetooth: hidp: use correct wait
 queue when removing ctrl_wait") to 5.10.y
Message-ID: <YR+9P8Na4PMXi72v@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

Tim Connors, a user in Debian (https://bugs.debian.org/992121)
reported that cca342d98bef ("Bluetooth: hidp: use correct wait queue
when removing ctrl_wait") from 5.11-rc1 is missing for the 5.10.y
stable series.

Actually would apply further back, but it was only tested to fix the
problem on 5.10.y

Thanks for considering,

Regards,
Salvatore
