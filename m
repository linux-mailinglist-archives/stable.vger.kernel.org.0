Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C861E1FF0D2
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 13:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgFRLo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 07:44:26 -0400
Received: from mail-eopbgr30046.outbound.protection.outlook.com ([40.107.3.46]:43746
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727784AbgFRLoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 07:44:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ua/zu7wgiXrfde+ECBDrYsZ7nr0Nl61N7lWfeepMGy77xvtak93NFiihrrMfD0Bqzz63MFUyNyHDOrmlLluBWu5axrjbIY2BFsrrQzO8tXGBytnRQzNHthLvS8pi9Ks4XylFDu+r+c3AyzEaWvMBfVJYo8zflXbfTvVnP6sp6jScOYn3zOBXYVytum/egWt+wjMOrGI3EjTm6GL23ao01HDU4DLWljHDp2a1M/Qtt5Yt/kYYydYtns/33ujoncDLj7qsEkcJPbOgbm+pu8lMFvfA270L0OF0MCmbTuBCEpfukaj5IElg8NUPYTAUePLlwoGShtfzqFL8GQxMhI1p+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1PXs6B0ZCT6TyfliGXgPCg7TwHVrn7ZRywrbuLRfFA=;
 b=ap7aMcGBfWTKGWNLPkD1VfuwRZDwjEq9BuhvN7nDqq0Ol7jR7sPTWKtOjLsfs1YITca/hP0CT4tiFR9ZZ17YQvqRrzBCoLmNtd3HcnWDCY1IJnr2nCgnxAqrnnlftWPMKxEWhTlCLKaH0w4GR33oI6kB8uXY0cQCSCPwdFaytBaXmxyfl0KXci2QftVU/H6YSSPfn7nTHe8UuIl1OaKJLjqX6At6kf/i+oMXzRxZQqtC5eE1HkvnrsGnotD9Yij2LDlv5QUfX872cbdrpaqzFwm1izYpLY3HpjPVnHhIv8UwMCuCDV/hYk8jTnLcjUsdT+XOSf0DOolD0pg0KC6Wkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1PXs6B0ZCT6TyfliGXgPCg7TwHVrn7ZRywrbuLRfFA=;
 b=e4p9Fa1HfypmLtyJFFJ5NVk5JA0LMyBrZrEzDvVi2H2iYcxZOJX/X3Lwl765e7HNj+SctBPk2t/S/krldWXVPnXBEcTKfjdyIoBqC6EFNy7erni2fgB49mn1HcqUMbW+VryXFFtMTAUshdAI9qGQHAm54X0UyaD8PQwaqmOrd+4=
Authentication-Results: alsa-project.org; dkim=none (message not signed)
 header.d=none;alsa-project.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0401MB2287.eurprd04.prod.outlook.com
 (2603:10a6:800:2e::19) by VI1PR0401MB2461.eurprd04.prod.outlook.com
 (2603:10a6:800:55::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 11:44:22 +0000
Received: from VI1PR0401MB2287.eurprd04.prod.outlook.com
 ([fe80::9d5c:685e:4b51:fa60]) by VI1PR0401MB2287.eurprd04.prod.outlook.com
 ([fe80::9d5c:685e:4b51:fa60%3]) with mapi id 15.20.3088.029; Thu, 18 Jun 2020
 11:44:21 +0000
Subject: Re: [PATCH AUTOSEL 5.7 055/388] ASoC: SOF: Do nothing when DSP PM
 callbacks are not set
To:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-55-sashal@kernel.org>
 <20200618110126.GC5789@sirena.org.uk>
From:   Daniel Baluta <daniel.baluta@nxp.com>
Message-ID: <1d1041f9-521b-98f5-a6ef-12d43615bc13@nxp.com>
Date:   Thu, 18 Jun 2020 14:44:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200618110126.GC5789@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0120.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::25) To VI1PR0401MB2287.eurprd04.prod.outlook.com
 (2603:10a6:800:2e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.100] (5.12.61.62) by AM0PR01CA0120.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Thu, 18 Jun 2020 11:44:20 +0000
X-Originating-IP: [5.12.61.62]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 05c51dd4-53f5-400e-868b-08d8137cf11f
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2461:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2461D167DB62294E2DB51F50F99B0@VI1PR0401MB2461.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLP9oEPa1rKzu/nbA8yZAu/lzUKH0utYRChAo9NkF5cXQyUPuUdu3qhzsoW8pymqVTMpa6xhidH347BrwXbozbXrI8w5oOk0QU2BAY00met4mUPH/778mxtYX2E+TZf5NSMztEd6mduktpLwLE679Uu2zYqkd+tR53UFCCsI/BiQq37GgUhm2hvP5M9pzA4cMUsiFm9uJ6aOlMW908nQ0Mr0TCO53DlMuRcIZs66Cesc58JIgcxaH5iS+eyPfc+cm1th2S5+oERmkcM+JTzL5G7Er3+kPfiA7PWj/sM/AHzavtHSJupc+a6f9G2wDnKzdtCU+z+cTNNCBKZQkCftKlsZyqqfQ/HbkxXuMXtAQ7yioqpI95zjmEZD8zDzSGZx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2287.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39860400002)(16526019)(31696002)(83380400001)(186003)(26005)(53546011)(4326008)(52116002)(44832011)(8936002)(5660300002)(36756003)(8676002)(2906002)(4744005)(478600001)(2616005)(110136005)(54906003)(316002)(16576012)(956004)(86362001)(66556008)(66946007)(66476007)(31686004)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8b8WrPJebbYTww5fjaMko/tILz0P/+69zAfd2JvCDtWMmuQWHDbWSgfNhCOMIIUFDZI8WJrYvaKVJy0gAr6TFINK0sUAJWAEW6dHWncoH8PBe7AgDBvJCxwanxXLlAPWwXtUrNVtKHXsX+TdF93FYIQTh7E9do/F8IOAjzGoUitHC7Kj5VDnB1yhOJeVGvI9gre0eNx+qfftBrnvZc+B2A6buRvIcwkzXWPZDUeh8hSEFGGPUTAigJkIKL/EGWI3hp3yuep9znJuAbKisX2J+nHA3b92QdkGkpM6k8xJtPvuTArSi09Xp2N9ohL/TWNmrtLOHllZDRZt/csiqJyjcgcl21GZFWDonMvvdIzJ9J3zuIEUVzZgJgsEYeVj8JMMs+N9JCeIxMTolrY6VorWj6OsN/mM3EeoI9mV7MxeriWNc8UwAh7H9sYaXhoTFNiLs3/0WsIcfUGhIQqGg3bpnPTmdkv6CsFggjeCFzGjEXo=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c51dd4-53f5-400e-868b-08d8137cf11f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 11:44:21.7361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0K50bqZKtj7cnhnLprVZ7PUUKEpR22ty9FizvzQx503DSDr//jPeGCz8S+Ezt/HaJK5UOUSfcCVQbm9A43iGVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2461
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/18/20 2:01 PM, Mark Brown wrote:
> On Wed, Jun 17, 2020 at 09:02:32PM -0400, Sasha Levin wrote:
>> From: Daniel Baluta <daniel.baluta@nxp.com>
>>
>> [ Upstream commit c26fde3b15ed41f5f452f1da727795f787833287 ]
>>
>> This provides a better separation between runtime and PM sleep
>> callbacks.
>>
>> Only do nothing if given runtime flag is set and calback is not set.
>>
>> With the current implementation, if PM sleep callback is set but runtime
>> callback is not set then at runtime resume we reload the firmware even
>> if we do not support runtime resume callback.
> This doesn't look like a bugfix, just an optimization?

Indeed can be seen as an optimization, but it does unexpected things 
which can cause trouble

and weird behavior for people not familiar with the matter.

For example, as explained in the commit message if you only provide

System PM handler but not runtime PM handler, then the DSP will be resetted

even if this is not the intention.

