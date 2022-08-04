Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A355558A3E9
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 01:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiHDX3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 19:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiHDX3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 19:29:05 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10081.outbound.protection.outlook.com [40.107.1.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275986068A;
        Thu,  4 Aug 2022 16:29:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E++uFPLvDOzsM+O/zGrEuxqxoHBYwkG6963CwI/pnkMMCMMO898LURZ5PuaSC8tJYeXq6VYWHUYm6Uwuc2pYEj4ZOmZgRF3otzyRteg5WyZV3+oxnVg/jrIRZgVA+FzhEODzcUQcB+luFLVF92i8lzIHvlCa7gXRxCZK2KMrN/YTf2F5c3o8sC6YmFhBacqVrgsPcToFik5jKRluvSTzE/hBtnuRNJpjgeT9Fu0kn04JP7EuICimLkKF0NdIRIWNgQBD50mfg4ncIIEm+6jUeUMV49eMa+8WM8VdbWgB2zYWZvYZloxZCzvLSNt55WV+LBjVjoO4bgs7qvDU5joXYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fGY7qMPdB60Yz6E3/XWA/u3RihMTT242gtqeH6j4GE=;
 b=MIbOacBWUWMTmJpWyos2ojbX7ze1KtOk+ZvhqjiJy22dJdgqF8qDeSD5Q8fzseAtO9YgS8jqV3reOPcdiGH7KCBGYSbH0wYt7Yi0q59G8eI+8cR0LiJsHijn+XxG3nN+E1Ms8Hn5YDdHnmQb4MX/i9QXvPZTf7jqaJdI53TgaaOAvui+paQaNAEKq65uHTy7R64WTqiZ/8TsMbd5+aEtKiyHX5NU8uvkYEDR8c4bbsLk9l5ORDrt4W71435M+PXWLfraxfU+JuOynkXRcHFBbnPS/U5CjR1R7bxE7ViIc/fyDYaDYBRDYrrBmDuuBMdItTYqOv2GHo3YhJOC1t9ewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fGY7qMPdB60Yz6E3/XWA/u3RihMTT242gtqeH6j4GE=;
 b=0LXYpWUyS5W3y+IRNSjZo5gfm5FGUoTCJygftTp1bMJZJcFeujZVbah9QC/rxnfH3gAOfyHHxXRgVd/AQEA2V+Pb/VIjmmgZv2itZzKp6/1QAJM9t0J/NCO0eurd/Q13QueccKMpQg1cZg7t1jMCj3+wDi4uyyrn3R4+w/GNgU2jR0veS/e7OAQG9U7SbjiXrvJtTTdTyRIStLmq6y7iYQC7i6vvTwk6LrkkniMnb3HLxnwynsbo68Ko4zi2mqjJfVbuSeT6HNn5uOWghzcp3efkSaQI3AVIt02uhpSFIcw75NjNbiaUkzVGRqkR/UI8NGyrjBRzoVyxR4556rFIkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB8478.eurprd04.prod.outlook.com (2603:10a6:10:2c4::13)
 by DBBPR04MB7659.eurprd04.prod.outlook.com (2603:10a6:10:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 4 Aug
 2022 23:29:00 +0000
Received: from DB9PR04MB8478.eurprd04.prod.outlook.com
 ([fe80::dc8c:f86b:777e:cd9a]) by DB9PR04MB8478.eurprd04.prod.outlook.com
 ([fe80::dc8c:f86b:777e:cd9a%9]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 23:29:00 +0000
Message-ID: <ee45d7c3-2034-20d9-9071-7829361313c8@suse.com>
Date:   Fri, 5 Aug 2022 07:28:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH STABLE 5.18 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Content-Language: en-US
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1659600630.git.wqu@suse.com>
In-Reply-To: <cover.1659600630.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::9) To DB9PR04MB8478.eurprd04.prod.outlook.com
 (2603:10a6:10:2c4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7986dd7b-3c17-48af-e190-08da76711bea
X-MS-TrafficTypeDiagnostic: DBBPR04MB7659:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2T0QrzZ41+iDQlvDvCJjmMdN0segIhUMufucVKJMay1CtVTYFTSi0M1sofAJKZgxtT1/7Vl5AtlrMxx2l2kqwzJz7z+SQU8KuEU68/cosra5rnza3k/tWjUnAtoQSTs7p8HOUESIpCJc7C7YO5Vg3wp0+NIjEA3osQKiZss+q9ByDmUSO88IPTcTtlypjl2FjzKqYQxb7gioD4us9QPyBINzumEoU8TyA4dslFjqCEpLfvFnKvKz5n/XqlbnQ480OhDzhO63cUWCFKyCEZFvzt3V2sH+t5uIU/07THHtD60LAjb2qQnhX9bLfA5+S2dditNnTe9LxBbSRBecqbiZZVjAxFDOlgMbRIDMWsGRNHq5h8WMznOUSwWbsVUYcAAMnApHjdyg2pJvm/lPXPWPpoP4X+UZ3PwPOhQInKEqjhrJYlipPi/tyoVl6/NwSNX73UEYgBbdkMjr9ENNmw/pgXLu2w8brrL7mG41cTx1Mk7K22JRBO19V/Yv2HMHOWyKfnQIt3W97Dw2KlvQ8sKaXyTCnKrCZSIQNsgRAcE/MfcqLEVyTpKiJuCYXx1AO6NHbL0MWXJCYvs6p/EPTnKNGnA9gDYPHQOPuIh9e8qtZulZaw26bAj5AjvqYk8PjQv6Gg7plhtP18odai1E+e9u4rvZHrXbljc4p/WLCRNCiukZ0IrfpNEiEfQ+o0ybB3TmgJkD2L0dPSw7hF8wwM9SmBj4L8ooH5vemQJlcWvpoeuCzK/+GOC2dYGLThY2pLdH3YjlVbcP46MbxkrzeHLkeu4FMPUz6ZEl3vFSITRJ+Hm4H7cbI7yGeub/KYZRHtRxezuUVFh2ZGbwJbFaz+ukZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8478.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39860400002)(366004)(346002)(6666004)(38100700002)(41300700001)(2906002)(53546011)(6506007)(186003)(2616005)(83380400001)(6512007)(450100002)(36756003)(66476007)(66556008)(66946007)(31686004)(8676002)(86362001)(31696002)(316002)(5660300002)(478600001)(8936002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dm1uZXF1QmpIVUl2cWpsb2xXUWF2Vi9ENHdvN01WNFZrdkhKWkltY1BsR2Ey?=
 =?utf-8?B?NFdGcmQ5Y2Uxdm9wZkFlMllUb2NxOVcyb2RwM3QvYTZsc3J6ZCtMaXpNTkdU?=
 =?utf-8?B?b0cxRnRpY1Fra3N2M0NybGtVY2ZrWDNjd1B3aUFWU0VPdCtLeWZ4eXhDMzgv?=
 =?utf-8?B?cTNhMWh5VHZ3ZWtMMzc2QmkrQkZoVXVjb1Y1WXhub1cxbnpjTnZOQ01PeXIx?=
 =?utf-8?B?QktHSzZmQklpZjdZNTVlYXFveVl4RDM0YktlcXE5dnV0UGpFZGE4UTRhMi9M?=
 =?utf-8?B?SDRmdmhRNHhDck9OU0JVa2hFL0w0SWRtUS9keVZtSkNuM1BMUXV0NDdVQmhC?=
 =?utf-8?B?NmJSaUdOb1BlUzVmTGFtL1VyOW5xMkZIS0E5eVh3YVFSZ09ybzVqVFFPQXBU?=
 =?utf-8?B?ZzlVaHdXTWs2UUVzcWhGNGNYQUtCN2pmQ1BUZ1haS2UzOFFzLzhnTjNkWG1z?=
 =?utf-8?B?Z3dRSDl4QzFOdzBOZ1dhVktvei81dTNRc0RaU21CeGdWZnBTV3JiSjJWR1VL?=
 =?utf-8?B?VWo4MjBPY0dXN2ZzVE45R0ltWExpUytpN3NLZUJSTkZpUytPU3JPMUxwbTN2?=
 =?utf-8?B?SUpua0dEb3JnYXdmNDlLNnNPb2s1dS9EaDVqMmdBcHhLbnBHQWpxNnViTURt?=
 =?utf-8?B?end2WTZZY05xTjZHVlFZa3ZUQzhrTHk1TFFEeGNVR2NpQXJtUWwvVGY3ZSto?=
 =?utf-8?B?ZnlSV1Vra0VQeXBrdjFpK2Nwc0lJUzVLRE5XVUxrRlhiOFNuQ1dVcDRuaXYy?=
 =?utf-8?B?ckdTUWlzTjA3R09lSDhrWDNCand2VXR0QUxLa1BwV3ZzSHRmRUhvZjhEd0Jp?=
 =?utf-8?B?ZDdHTUZFSGVqTVNnL1o1N0JHV3lvWXo2T05jMEhreVpadFJTUll3alJpM3BG?=
 =?utf-8?B?LzBHRUpaWUUrL1JkMWdCWnBSL1FjNm5BUWNLRDVNNW5uOFNlRUtjUnZTdldF?=
 =?utf-8?B?SUl6T2ZScWRmK1FJNXlYS0ZCdmNMbk1Yd2diTVY4WDdWN0ovRXhWSi9rUllo?=
 =?utf-8?B?L3lYckZ6VnBWRWtkMHdCV1Y4eiszSWlZRjM4QjdKVWF5SmwydDF4MnlUSXVO?=
 =?utf-8?B?cFNnY2NGVzJjRGxuNUZzMlJhSGdrWFNqT3BYVW94QkptYlM5QXVOaHoxSUg0?=
 =?utf-8?B?dzMrWmwzMkNpa2ptM1IyRkdaSmZWRzlYbzVDYVVyZldSYjBnbWs4Z0pnMUwx?=
 =?utf-8?B?TlY2Tk96NkhrYmF2ejI0QjJkcDhGWVFGV21ERDRBWm5KUFVqbUtXY0s3K0Er?=
 =?utf-8?B?THExQ3A5QlVzVkF5RWZZMHpBT1BlRC9MVjhzZ3pEOHNoT3hFekN6NlJlcmZR?=
 =?utf-8?B?V2o0TkVpTm9sS1QwOVZ6UXI2SnFjNUhOM3luYVBqNUN0K3hHVEZGMi9sT09X?=
 =?utf-8?B?Uk1FYkM5WTZCV05aV1Q4ajJwT0dLQmpBMjZScHc0RjZTQzlMZlpHbVRaT3Na?=
 =?utf-8?B?dnBDUkczWnhGWXF4REhDQUcxWlE3eVpKT2d0OXV3bDR3SEx5SmkwY240Um9k?=
 =?utf-8?B?MVRPeUhrSlpWaDlPSE1CdkN6b2lJWkliWDEzZXVLZTZiTXJQd2NmYldxZ1VQ?=
 =?utf-8?B?VW05c2pTMHo4cnlIRk1rTUdYaFo4UjYwRFlhQW1jdG44NmMrQlFnUzNJeGhn?=
 =?utf-8?B?dzJzTVZlaUp0c0ZkK0I2RTVuUnlCMmNLdURUWE5BMnk5Zjl5NEdCVWZrWG5u?=
 =?utf-8?B?dkFQN3dZYWgreFZlNVZ3aUhvU25oamFiNDZ1RVBsQnd6STk2elN4Nm1UOEFm?=
 =?utf-8?B?REM4M1NZajZScHIzZTM4dmx3dnlqUjR2SWhEc1J3SzZJaEEzWEJoVGdmRkFE?=
 =?utf-8?B?dVVobGRSNS9sTTE1N0lJN0YrUVVpMndLY0l5ak5vSGExNEhjUjdBOHZaM1JE?=
 =?utf-8?B?V3BLdTVJNUhaK21oZTVvZXFCN2tDb1N0TUpGb2xKZ0ZDUTI4cC9CRnp4TXdr?=
 =?utf-8?B?VFlXc1lsQ1JaY3E0SVhxaFJ2ZWhka2ZBMG5CRnBUSzhuR1FIYmMxbzZXY2dX?=
 =?utf-8?B?RWdUZWJKMUJhMkdXbW9iOFhSZXNlL2tkODIzemVnTDEyWUlUdzU0bFd2Tld0?=
 =?utf-8?B?VDNZbEtzaGdNMlBnR1JSbnZzUE1uKzdiZWJXMnJKV2hOY0lpTjZRZnI4UlNw?=
 =?utf-8?B?ajA4M0syUElhdlNjaEtUNjBiYlhtQWlsTjQ5Tm9SeENYZDF1Y255S2h2VERm?=
 =?utf-8?Q?SRygzK8LsdFIGOWuP1ruMW4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7986dd7b-3c17-48af-e190-08da76711bea
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8478.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 23:29:00.0917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cEsHeZymudKu0BQmdc5FpWjXe02/aENkQWgZ30Y5wm9+dSyClfknTLcyGcblcDj4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/4 16:10, Qu Wenruo wrote:
> Hi Greg and Sasha,
> 
> This two patches are backports for v5.18 branch.
> 
> These two patches are reducing the chance of destructive RMW cycle,
> where btrfs can use corrupted data to generate new P/Q, thus making some
> repairable data unrepairable.
> 
> Those patches are more important than what I initially thought, thus
> unfortunately they are not CCed to stable by themselves.
> 
> Furthermore due to recent refactors/renames, there are quite some member
> change related to those patches, thus have to be manually backported.
> (The v5.18 backport is more like the v5.15 backport, with small tweaks
> due to member naming change).

Just to mention, thankfully the crash in v5.15 backports are not 
affecting v5.18 backports.

The uninitialized btrfs_raid_bio::fs_info is solved by the commit 
731ccf15c952 ("btrfs: make sure btrfs_io_context::fs_info is always 
initialized"), which is already in the tree.

Thanks,
Qu
> 
> One of the fastest way to verify the behavior is the existing btrfs/125
> test case from fstests. (not in auto group AFAIK).
> 
> Qu Wenruo (2):
>    btrfs: only write the sectors in the vertical stripe which has data
>      stripes
>    btrfs: raid56: don't trust any cached sector in
>      __raid56_parity_recover()
> 
>   fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 57 insertions(+), 17 deletions(-)
> 
