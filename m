Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668682DA6F7
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 04:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgLODzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 22:55:43 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:38858
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLODzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 22:55:43 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glks-stable4@m.gmane-mx.org>)
        id 1kp1QT-00062t-Ms
        for stable@vger.kernel.org; Tue, 15 Dec 2020 04:55:01 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     stable@vger.kernel.org
From:   Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
Subject: Re: [PATCH v2] ASoC: AMD Renoir - add DMI table to avoid the ACP mic
 probe (broken BIOS)
Date:   Tue, 15 Dec 2020 16:25:28 +1300
Message-ID: <e1097123-6f22-8921-0415-248958c2a952@blennerhassett.gen.nz>
References: <20201208171200.2737620-1-perex@perex.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
Cc:     alsa-devel@alsa-project.org
In-Reply-To: <20201208171200.2737620-1-perex@perex.cz>
Content-Language: en-GB
Cc:     stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/12/20 6:12 am, Jaroslav Kysela wrote:
> Users reported that some Lenovo AMD platforms do not have ACP microphone,
> but the BIOS advertises it via ACPI.

Can you briefly explain how to confirm that this specific problem
exists, and what info you would need from me to add a new machine?


I have a Lenovo E14 Gen 2 with AMD that claims to have DMIC but no
evidence of it working.

My workaround so far has been blacklisting the related modules...
blacklist snd-soc-dmic
blacklist snd-acp3x-rn
blacklist snd-acp3x-pdm-dma

alsa-info:
http://alsa-project.org/db/?f=0c4d6f062e6065d47ee944f5953f0aaa328d4b44

--
Eliot


