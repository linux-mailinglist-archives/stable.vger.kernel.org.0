Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C434AD27D
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 08:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348535AbiBHHtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 02:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbiBHHtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 02:49:14 -0500
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 23:49:13 PST
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FAFC0401EF
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 23:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644306552; x=1675842552;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=0aEGFIMCaOfJGSzlekXF48KH7peAg+faNjJmKJs1d24=;
  b=W5M+o5sNEA070pjzz4qnrBia+vPgUp7L/1hkqXTCnJPetmI88G1KnJEQ
   ixpuxqkBFOq6tDRKfK2LJ3g+uu5FFQnVQUhvuQZeXXr2Sa67RjnlVltGb
   m+zIHx6srlwguY0wu5WN/VO9thO35JZwsBFvsiUn4/kf9NDtbipkvf+Je
   d6S4Swf1OBaB/u/IfKQeQcLcLZRSpqlBULd2SZxUJ12pBAZX63cbw6H2h
   HR8eQKf3/Nh6d8swLNeZP1lItR5nMdv6UY5mbqH0mIN+s1lQK/TUS3CG7
   yvH2TrDPAFgUJyHL9pxyi7hGnOVMO8bRyeaumSU6FMDLMdMjAod4B2KQi
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,352,1635177600"; 
   d="scan'208";a="192395798"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2022 15:48:11 +0800
IronPort-SDR: +Sz8uDERMvnr4Onc9MhFVE6vayR4CpPnBFA6lA+dX9o3MQqwxDllc7VwlINzuRiQcC5Tpra9tg
 Ax157yMX+Kx9/jpFV41nzRhgIRaHiNpXUmHCBeUMZ+rcMvQr5H9eNU1IgrjWyjyTjCfBLJtFk4
 ORixEIXVuLV6OqNdv4RlGIxBl1W+j/DZ6pDbxoBkBR6V9njO9unlKQzFjP9Z5OlzntYlWjQsE1
 WGFE8jKG6C3bg1W6Y+xKLz1BUN9L4/1INOOxkuaMUeps+Osid5MhDocXYczQa8qaP4/eKeAv9o
 oL+SWFOg9l+e0BKx5xJr6w61
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 23:20:01 -0800
IronPort-SDR: Cx5Y4igwa+3VA/ZHARhdAsIgo+MEKgMeZ5uMz6vQF2/GSwUwfjkxY+BzerOuVKLl04hTEG8VBn
 yIMYJOSD5PB2YCAaIsayUZNY1RWDxMZu9vBPFoI7aZifR9JMqMXghMk/DkxyVUhK1VE7x6tiIG
 LVpRJcNnsezOXaNcvjWA4iFO0QJ1fjzMFiBih5yrKAUAagt0jBUCbdpf7U4VYQvXqDL5baqlQR
 Hx92XeTr7I4W7IrCh3KayA5XXakq26YFcX205G7Ux2zUI+E3APzKITlz0+UB4lYtea4/Y9n4EB
 iNw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 23:48:12 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JtFVg0rNFz1SHwl
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 23:48:11 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644306490; x=1646898491; bh=0aEGFIMCaOfJGSzlekXF48KH7peAg+faNjJ
        mKJs1d24=; b=ZYv1gLJJpDKnwrw1SQPCvA9x4LiL2L+q6zIK2LB5nTv/DaciQ1w
        T3zj0pj1Bk7JlVwvnUTTRcdkr2y6OxbIgj5K0w+uz1Th7Q1btBPjcaM0RGRCQ7Sw
        H9G6E8oXxkjU5a7rZNCPZTUr20q5HLrTkDGq5a7IadycOcylPalBKeC3xlw+A28l
        QQG1/172zH9iBYWPGcslEkmCbcXNNndkzvL+ZT23RCUn1ZSoqHfn75qmWqXqzh2d
        AM6LTGHzW+SU2sDi9RrV9o+AsZF2UHmR8Yu1q71fgh3b31Dyr5NTGmaNeiexUwRB
        oPNZX/ggeFmgd1Gs6zXpvX7rilAvRzJEDzA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kexKGA0x7zPa for <stable@vger.kernel.org>;
        Mon,  7 Feb 2022 23:48:10 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JtFVf0vtTz1Rwrw;
        Mon,  7 Feb 2022 23:48:10 -0800 (PST)
Message-ID: <13bf2b16-9a7a-9e6a-4c40-cb5e3a8ca061@opensource.wdc.com>
Date:   Tue, 8 Feb 2022 16:48:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] ata fixes for 5.17-rc4
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     "Justin M . Forbes" <jforbes@fedoraproject.org>
References: <20220207140450.1072531-1-damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220207140450.1072531-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 23:04, Damien Le Moal wrote:
> Linus,
> 
> The following changes since commit dfd42facf1e4ada021b939b4e19c935dcdd55566:
> 
>   Linux 5.17-rc3 (2022-02-06 12:20:50 -0800)
> 
> are available in the Git repository at:
> 
>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata tags/ata-5.17-rc4
> 
> for you to fetch changes up to fda17afc6166e975bec1197bd94cd2a3317bce3f:
> 
>   ata: libata-core: Fix ata_dev_config_cpr() (2022-02-07 22:38:02 +0900)
> 
> ----------------------------------------------------------------
> ata fixes for 5.17-rc4
> 
> A single patch in this pull request, from me, to fix a bug that is
> causing boot issues in the field (reports of problems with Fedora 35).
> The bug affects mostly old-ish drives that have issues with read log
> page command handling.
> 
> ----------------------------------------------------------------
> Damien Le Moal (1):
>       ata: libata-core: Fix ata_dev_config_cpr()

Greg,

Could you please pick-up this patch for 5.16 as soon as possible ?
The bug it fixes is affecting some Fedora users, among others.

The commit ID in Linus tree is:

commit fda17afc6166e975bec1197bd94cd2a3317bce3f
Author: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date:   Mon Feb 7 11:27:53 2022 +0900

    ata: libata-core: Fix ata_dev_config_cpr()

Thanks !

> 
>  drivers/ata/libata-core.c | 14 ++++++--------
>  include/linux/ata.h       |  2 +-
>  2 files changed, 7 insertions(+), 9 deletions(-)


-- 
Damien Le Moal
Western Digital Research
