Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647ED5B5A59
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 14:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiILMpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 08:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiILMo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 08:44:58 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6786CFD1A;
        Mon, 12 Sep 2022 05:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com;
        s=Selector; t=1662986696; i=@lenovo.com;
        bh=HUiY5ZSFaKzk5IbKH3JLlafevURlIyS/17H7EWwEVfk=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:CC:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=2NAjkTWAm/13y7mX7WuiqVZvBvaapGglKGFeUSgddXQC0vGdk6v10qPevvgtqiTTO
         zRYICwR8MkvHykOwcx0JlVNoD0jUl4GZQeSDf9Ocjpu8w26Rc+0d3H3cq7jdKQRtNd
         NTN1BldheR8S+wxmqZH11YPpsxATPgwlvgejvFn//ZaNJrWKWAAfCcXtVwOokMquNN
         NYUyZQYwu35PLi69sGTbjP7I6o6/dcRWliCsDNNBXXbK196PPel/bZwGNjYTkZJMJK
         YDVn54wHkvdw5GlyKJ+YURasuB6CR1R5Pw+aGSYoiD320pertNPeP7vpgE3AJdMUpo
         /3xtudSy0brtQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJsWRWlGSWpSXmKPExsWSoS+Vq3tcUz7
  ZoLPJzOLBVSmLz71HGC3mfpnKbHH3tZ/Fgo2PGB1YPXbcXcLosWlVJ5vH501yHpP/PmUOYIli
  zcxLyq9IYM048+QfW8FZmYqu50fZGxhnSHQxcnEwCixllvjZ2MwG4SxilXgz7wMzhNPBJNFz6
  Rs7iCMksJRJ4sqV+0wQzmEmiT3Xu4B6ODkkBI4zSnSvcodIdDJK7N76AywhJDCBSeLETCmIxB
  NGiWfPD0K1P2KUaN/Qz9rFyMHBK2ArcXFOEkgDi4CqxLk/vYwgNq+AoMTJmU9YQGxRgUiJc+3
  zmUFsYYEUiTkr2sFsZgFxiVtP5jOB2CICWhKfb75ngli8kVli+94UkF3MAucYJY50nwBLsAlo
  S2zZ8gvsOk6BWIlbp7cwQgzSlGjd/psdwpaX2P52DjPEIGWJX/3nmSHeVJB40XgQ6uUEieYpR
  xkhbEmJazcvsEPYshJHz85hgbDtJQ6+bIDq9ZXoWHwOKi4ncar3HBOELS+xc+NtlgmMqrOQ/D
  wLyW+zkJw3C8l5CxhZVjFaJRVlpmeU5CZm5ugaGhjoGhqa6JqZAym9xCrdRL3SYt3UxOISXSO
  9xPJivdTiYr3iytzknBS9vNSSTYzARJVS5My9g/HXyp96hxglOZiURHmfSsgnC/El5adUZiQW
  Z8QXleakFh9ilOHgUJLg/akGlBMsSk1PrUjLzAEmTZi0BAePkgjvKZBW3uKCxNzizHSI1ClGS
  44r2/buZebYtK/rADNH534gKcSSl5+XKiXO+0MDqEEApCGjNA9uHCyxX2KUlRLmZWRgYBDiKU
  gtys0sQZV/xSjOwagkzHsaZApPZl4J3NZXQAcxAR00x00a5KCSRISUVAOTxCMeX8HJS5K8Dh6
  wCj2vsU5lUuWdIM1XdiqMLz/fP7HwIFv75qdWl+ze5jj8jLuwK3bVgacHM7br9cz4P2dBbWLp
  ok0X88R3Mooc+fPmv92ewjclvxMepx5cyitZ+kagUXh5UUjpg0P1lZb/P7nfNOM17qnwKQ7YV
  BnHnHBn/vbDlanJ8ie+d/RUXJwZL//arUdpGZPISRXbmfXNDu3zmJ/83WmepP/M5c+6oPurhE
  M//eFVdf7mYGF5eJGauUMBf/yLcL5pfzMf2xzRMJxZzZnh5trGcC2K/ZjW/95CtukTrWau/zF
  5t9lBu66slouXMpu3i/gxGEYYis1VXTFd6P48KZ+iACXvIhnRv8ZKLMUZiYZazEXFiQC2V6S5
  ZwQAAA==
X-Env-Sender: markpearson@lenovo.com
X-Msg-Ref: server-11.tower-715.messagelabs.com!1662986693!62597!1
X-Originating-IP: [104.47.26.109]
X-SYMC-ESS-Client-Auth: mailfrom-relay-check=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 21818 invoked from network); 12 Sep 2022 12:44:55 -0000
Received: from mail-sgaapc01lp2109.outbound.protection.outlook.com (HELO APC01-SG2-obe.outbound.protection.outlook.com) (104.47.26.109)
  by server-11.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 12 Sep 2022 12:44:55 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQeU2Iyz0Xvc5hesMKaQQXITlKZLjz1P0HlD6gmoxPfFOH+9cKAkBRSK3bzlqQbRtzf1J+vEtw6LA6U8SieDOJ1psVmyMMwNvpMzA7/ClGfR+10InDxge/7qBwgqDqy4cbFrjtXJyITQ7pPncC6Ak2ObKolMHPs/ppLvlLbiMnyZBO+KpMYFwKhcILr6hvtptdhT6p0lM6Aulg5Z+j8NycOeOfrACjY1EEwU/AEtrs5qmQsyU1PV6EMwIqPX7ddX0gVKbWQETAEnbl5n/xzBLZo70sDKtO2IP6+uShVmigR8i5v7xyXWNFoWEZXJ1xMsLu4J0vOwI/Ey2V9rWt9B3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUiY5ZSFaKzk5IbKH3JLlafevURlIyS/17H7EWwEVfk=;
 b=FQ4O0Bw3CbJDuLonV5XOG3XncamDqTnAAC4L5Zc+t3FAxXhos28AzVjXo+7IUNHmg+lrEedndGyn7C2LT7Z05SLXl0f657oR3ApuaNDXPh11X80g3U9jbElYCqPC2DMoNaNYXvutcpbQzWuq/IsWuNdIOcb4AzKNPSNE+ihTx/vt6j/4psOVgEPCPShwnzHzKkdEv3sFLCDskfy9Par1+nR63kXxwhNZVd7Z/oCqvSGaso8EB2dBRq5Ac62yXJ7qZf8LaZv+e09aL6RnSP1e61dJPl4O3cSgbJ4n7UEP0DERZmI9b7OnkJvLZmdy9Hsnb8ydXncfmQyvzZlqVXls8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 104.232.225.6) smtp.rcpttodomain=zx2c4.com smtp.mailfrom=lenovo.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=lenovo.com;
 dkim=none (message not signed); arc=none
Received: from PU1PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:803:15::34) by TY0PR03MB6259.apcprd03.prod.outlook.com
 (2603:1096:400:137::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.12; Mon, 12 Sep
 2022 12:44:52 +0000
Received: from PSAAPC01FT029.eop-APC01.prod.protection.outlook.com
 (2603:1096:803:15:cafe::5d) by PU1PR01CA0022.outlook.office365.com
 (2603:1096:803:15::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22 via Frontend
 Transport; Mon, 12 Sep 2022 12:44:52 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 104.232.225.6) smtp.mailfrom=lenovo.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=lenovo.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 lenovo.com discourages use of 104.232.225.6 as permitted sender)
Received: from mail.lenovo.com (104.232.225.6) by
 PSAAPC01FT029.mail.protection.outlook.com (10.13.38.189) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.13 via Frontend Transport; Mon, 12 Sep 2022 12:44:51 +0000
Received: from reswpmail01.lenovo.com (10.62.32.20) by mail.lenovo.com
 (10.62.123.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2375.31; Mon, 12 Sep
 2022 08:44:49 -0400
Received: from [10.38.48.185] (10.38.48.185) by reswpmail01.lenovo.com
 (10.62.32.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2375.31; Mon, 12 Sep
 2022 08:44:48 -0400
Message-ID: <c2f52c92-bdb1-c870-17d0-9cb05a4d3d45@lenovo.com>
Date:   Mon, 12 Sep 2022 08:44:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH RESEND] power: supply: avoid nullptr deref in
 __power_supply_is_system_supplied
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <CAJZ5v0js78b3qZXoxgXEwG7g0a7n_ALnEYjjzBGaQW7q4_ceCA@mail.gmail.com>
 <20220905172428.105564-1-Jason@zx2c4.com>
 <20220911123346.a7xbzdlbb7r5p6ih@mercury.elektranox.org>
 <Yx8N0hGNcbVPnJxW@zx2c4.com>
 <CAHmME9popsZskH5xR0sX2Prhd_R78Dc9mEO3BKy6qcvaok1MXQ@mail.gmail.com>
 <CAHmME9qUirnDQCxLvcQPTVYjSXEgGZcTnYTfRRVkVUwziFTywQ@mail.gmail.com>
 <TYZPR03MB599467EF3E0F17E72DF47E86BD449@TYZPR03MB5994.apcprd03.prod.outlook.com>
CC:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
From:   Mark Pearson <markpearson@lenovo.com>
In-Reply-To: <TYZPR03MB599467EF3E0F17E72DF47E86BD449@TYZPR03MB5994.apcprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.38.48.185]
X-ClientProxiedBy: reswpmail01.lenovo.com (10.62.32.20) To
 reswpmail01.lenovo.com (10.62.32.20)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAAPC01FT029:EE_|TY0PR03MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 6674dca9-eaf5-4567-f98c-08da94bc9605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8jZgGnU5q4wWSJXv0Z0t+RP8Lw1fFvotMqCFZSbpiYvfwgRtJ9luXjJ1VZMM/3Qa76fH8291oHaDJ10pit1gK3vFlOzqH7zPyHdDFGUqwbnt6hFET9Ssfs0wdlcd0EHTOXBbOMeJRLalCgxKu/tbNYZzI5PvmGeJu1ldC9D2AdTQdODOO7frhy7JaOKrpP2QdjyTtac0Ye5l/lKkbnSPposyaHqsCJpnFZEpFG/JoFIUWcSqQlgXx1Sxroh/3TZKywYxbCeP5ObD6BoMEsoLmGx4Yswwl2klkMciSEw7MFPCio3o3IuNQlyelwkqooVm7KelLecB+r3uuKHwcVzN/jOT7UW8UCCDwGLWiwezIkqGU2+Dn8UthkWi5zVuXhcQgqciW2VK+gvWenzOeooCPgUWf3kI1E557cI8ZxINna3fovxRmtXBxIS0UOBfKl51g28CgMLV345QHLeOLzu1XtFSMydAXWtIwNzsE6eUyVqu0cisXXrhPmGiYABxE69F/cB1PXR8yM5JpMjrIX5nu+7FtsZA38+stKtDPWC8XuWR0kNH4uVJ+nCUDF48H9zLYqkmApMvCX6xkpc6GJgC+Kpd81sf5UOexjkGI9kBEvZq8S8p5g2iLPg8lSrq4RkhSxMOavb5VFWnG8wSMnUOMxH/3RYdSNDkGjBHGVRH3pjtr+Kc94e/FTAX6koplkG3gTlpdLk5EbwKbucLISruzmxg+RHn0VtCavbQuZj5NRnXIGXx2CGWw5OMylFGY8wBgQnfG0wc99HJQN7bjAi4Pu6edIviH34KzkJVLqdk4HCEB5qJG/pSsksAIQqR8iIspcYGzZsuvtlNVfML7jF6zbog5nfnA/V/nUsIVAw/+Bfivm+rwrJ5Pp1zWr+SxQfqR1gXxhYLvkPR/C1Z4lCmIA4+Q23S6vLWIV6lu8pHZ7QSDmPmACoxK6nCeRGB6Mu
X-Forefront-Antispam-Report: CIP:104.232.225.6;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.lenovo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(39860400002)(40470700004)(46966006)(36840700001)(31686004)(86362001)(31696002)(82960400001)(356005)(8676002)(81166007)(70206006)(4326008)(70586007)(36756003)(82740400003)(36860700001)(47076005)(83380400001)(426003)(336012)(2616005)(53546011)(478600001)(41300700001)(6666004)(966005)(26005)(8936002)(36906005)(82310400005)(316002)(40460700003)(40480700001)(6916009)(16576012)(54906003)(16526019)(186003)(2906002)(5660300002)(3940600001)(36900700001)(43740500002);DIR:OUT;SFP:1102;
X-OriginatorOrg: lenovo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6259
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<Note - hope this works - moved to my more opensource friendly email
account>

On 2022-09-12 08:20, Mark Pearson wrote:
> 
> --------------------------------------------------------------------------------
> *From:* Jason A. Donenfeld <Jason@zx2c4.com>
> *Sent:* September 12, 2022 6:56
> *To:* Sebastian Reichel <sebastian.reichel@collabora.com>; Mark Pearson 
> <mpearson@lenovo.com>
> *Cc:* linux-pm@vger.kernel.org <linux-pm@vger.kernel.org>; 
> stable@vger.kernel.org <stable@vger.kernel.org>; Rafael J . Wysocki 
> <rafael@kernel.org>
> *Subject:* [External] Re: [PATCH RESEND] power: supply: avoid nullptr deref in 
> __power_supply_is_system_supplied
> CC+ Mark Pearson from Lenovo
> Full thread is here:
> https://lore.kernel.org/all/YwDsy3ZUgTtlKH9r@zx2c4.com/ <https://lore.kernel.org/all/YwDsy3ZUgTtlKH9r@zx2c4.com/>> 
> On Mon, Sep 12, 2022 at 11:48 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>>
>> Ah another thing:
>>
>> On Mon, Sep 12, 2022 at 11:45 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>> > My machine went through three changes I know about between the threshold
>> > of "not crashing" and "crashing":
>> > - Upgraded to 5.19 and then 6.0-rc1.
>> > - I used my laptop on batteries for a prolonged period of time for the
>> >   first time in a while.
>> > - I updated KDE, whose power management UI elements may or may not make
>> >   frequent calls to this subsystem to update some visual representation.
>>
>> - Updated my BIOS.
> 
> GASP! The plot thickens.
> 
> It appears that the BIOS update I applied has been removed from
> https://pcsupport.lenovo.com/fr/en/downloads/ds551052-bios-update-utility-bootable-cd-for-windows-10-64-bit-and-linux-thinkpad-p1-gen-4-x1-extreme-gen-4 <https://pcsupport.lenovo.com/fr/en/downloads/ds551052-bios-update-utility-bootable-cd-for-windows-10-64-bit-and-linux-thinkpad-p1-gen-4-x1-extreme-gen-4>
> and now it only shows the 1.16 version. I updated from 1.16 to 1.18.
> 
> The missing release notes are still online if you futz with the URL:
> https://download.lenovo.com/pccbbs/mobiles/n40ur14w.txt 
> <https://download.lenovo.com/pccbbs/mobiles/n40ur14w.txt>
> https://download.lenovo.com/pccbbs/mobiles/n40ur15w.txt 
> <https://download.lenovo.com/pccbbs/mobiles/n40ur15w.txt>
> 
> One of the items for 1.17 says:
>> - (Fix) Fixed an issue where it took a long time to update the battery FW.
> 
> So maybe something was happening here...
> 
> I'm CC'ing Mark from Lenovo to see if he has any insight as to why
> this BIOS update was pulled.
> 
> Maybe the battery was appearing and disappearing rapidly. If that's
> correct, then it'd indicate that this bandaid patch is *wrong* and
> what actually is needed is some kind of reference counting or RCU
> around that sysfs interface (and maybe others).
> 
> Jason

Hi Jason,

I'll have to check with the FW team but looking at the internal notes I
think the FW was pulled because of a graphics display regression.
Version 36W was fixing a brightness control issue in discrete mode and
37W (not yet released) is fixing external display - so my guess is
something about the fix in 36W has a side effect

More interesting is the EC FW updates. There isn't a new version posted
but there are fixes in the previous version (EC 33W) for a fix for a
'suspected EC-Battery communication transaction failure'. Is that
potentially related to this patch in some way? I can go and ask for more
details if we think it's related. I'll also see if I can repro on my
P1G4 - but I hadn't seen any other reports so it might be HW specific.

Can you confirm which FW you have from the BIOS setup screen (F1 during
early boot)? BIOS and EC please.

Mark


