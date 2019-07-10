Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7464DEC
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 23:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfGJVMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 17:12:31 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42694 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfGJVMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 17:12:30 -0400
Received: by mail-lj1-f196.google.com with SMTP id t28so3516637lje.9
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 14:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gwvajVWMIb62q8wACGYhWs29kEXd/GDO5w+T3eFYJVQ=;
        b=ix9E8oHqVOHHI7+NbnlUqfsJnN4HBLwyr0Jn9m3Tpk6LEOunHnYze3vGWP8/aAN+JQ
         o8Xb6a4lS1X88VxaIJw7qDyL2rtrdl8yPiVKxFJVDlBDzUn/5GBcvnogmRiipUUSaZ2A
         y62oVYOH++N07WuupIrdvk0x7owfObLe29Q5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gwvajVWMIb62q8wACGYhWs29kEXd/GDO5w+T3eFYJVQ=;
        b=Me9cYKK44094hWQT+f3y04cORa7+RBpaFuDZhHoLNx8EoUBk1iWui7p/VpsiXz2fQV
         og/EO8nBoaU4J4UZAvONFoKfXr6DFuS/tZVbGp1P/xZUAtfmNxyDBgqYUlQQRRp7aYAl
         OuocyKvyZkBTarA/9s6mZ4aCnmwRJPujQT/yQrTOolMtuDGOKGf0onekiwbH/rmbRc8x
         CdfJAcfgN9zw1iMZSDQqq80iq76t0gXZUUizr/2mXThjMBCUc5HYTNKKN4M20PfWjPLh
         voa8O0AKDn38I1HVea49ksUMacNhEK5e4CucxEQuzwOxxJLwWR7mQKm+IFEk1mmildPy
         t3WA==
X-Gm-Message-State: APjAAAVNcILjdMp205BxpVA35gI+dqiksJX4kx4ZRtYHbir7n8x70zZU
        he3O/LIFazDRVrkfYH68esTK90S8jU4=
X-Google-Smtp-Source: APXvYqw56U6c7dSyPGNyHM5Iu7Dx1i9hi5lbKyp8ffigbpchp6FRsY5tKPdJ8KXQyOE/ylMLojHhXQ==
X-Received: by 2002:a2e:9209:: with SMTP id k9mr175370ljg.96.1562793147976;
        Wed, 10 Jul 2019 14:12:27 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id 63sm653575ljs.84.2019.07.10.14.12.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 14:12:26 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id c9so2578747lfh.4
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 14:12:25 -0700 (PDT)
X-Received: by 2002:a19:6519:: with SMTP id z25mr6190697lfb.42.1562793144979;
 Wed, 10 Jul 2019 14:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190627003616.20767-1-sashal@kernel.org> <20190627003616.20767-14-sashal@kernel.org>
 <CA+ASDXPyGECiq9gZmFj8TU6Gmt2epQtuBqnGqRWad79DJT589w@mail.gmail.com> <20190710145112.GX10104@sasha-vm>
In-Reply-To: <20190710145112.GX10104@sasha-vm>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 10 Jul 2019 14:12:12 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPseNZkud1vu9zaRH-vA0rJq8D_t6pFG1LTPQtdr8_eVA@mail.gmail.com>
Message-ID: <CA+ASDXPseNZkud1vu9zaRH-vA0rJq8D_t6pFG1LTPQtdr8_eVA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 14/60] mwifiex: Abort at too short BSS
 descriptor element
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 10, 2019 at 7:51 AM Sasha Levin <sashal@kernel.org> wrote:
> I see that 63d7ef36103d didn't make it into 5.2, so I'll just drop this
> for now.

Yeah, I think it's stuck at net/master. Presumably it'll get into
5.3-rc somewhere.

Brian
